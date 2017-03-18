//
//  SubscribedPagesViewController.swift
//  kcuc
//
//  Created by Yuki on 2016/12/25.
//  Copyright © 2016 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class SubscribedPagesViewController: UITableViewController {
  var viewModel: PagesViewModel!
  let center = NotificationCenter.default
  
  // MARK: Actions
  @IBAction func changeEditMode(_ sender: Any) {
    if(self.tableView.isEditing == true) {
      self.tableView.isEditing = false
    } else {
      self.tableView.isEditing = true
    }
  }
  
  // UITableViewControllerのsubclassで正しくinitializeを行う方法が曖昧…
  required init?(coder aDecoder: NSCoder) {
    //fatalError("init(coder:) has not been implemented")
    super.init(coder: aDecoder)
    
    addObserver()
  }

  deinit {
    removeObserver()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let navigationButton = UIBarButtonItem()
    navigationButton.title = "戻る"
    navigationItem.backBarButtonItem = navigationButton
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if viewModel == nil {
      guard let userId = UserDefaults.standard.object(forKey: "kcuc.userId") as? String else { return }
      
      let pagesParameters: [String: Any] = [ "user": userId ]
      
      PagesViewModel.initialize(with: pagesParameters) { (viewModel, error) in
        if let _ = error {
          return
        }
        
        self.viewModel = viewModel
        self.tableView.reloadData()
      }
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.subscribedPages.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "subscribedPageCell", for: indexPath) as! SubscribedPageCell
    
    let page = viewModel.subscribedPages[indexPath.row]
    cell.set(page: page)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let page = viewModel.subscribedPages[indexPath.row]
    
    DDLogDebug("href: \(page.pageHref?.absoluteString ?? "no referrer")")
    
    if let absoluteString = page.pageHref?.absoluteString {
      let viewController = PageViewController(url: absoluteString)
      
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
  // cellを削除可能にする
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // Deleteが押されたらcellを削除する
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete {
      guard let userId = UserDefaults.standard.object(forKey: "kcuc.userId") as? String else { return }
      let href = viewModel.subscribedPages[indexPath.row].pageHref?.absoluteString

      // Cloudantから該当のページを削除し、削除後のsubscribePage一覧を受け取る
      DescriptionManager.unSubscribePage(user: userId, href: href!){ (result, error) in
        // nilチェック
        if let _ = error {
          DDLogDebug("Error: \(error?.localizedDescription)")
          return
        } else if result!["code"] as! Int != 200 {
          // subscribePageの結果は失敗でもJSONで返ってくるので、中身のステータスコードをチェックしておく
          print(result!["detail"] as! String)
          return
        } else {
          print("unsubscribed page")
        }
        
        // 削除後のsubscribePageを使用してviewModelを更新
        self.viewModel.updatePagesViewModel(json: result!){ (updatedViewModel) in
          
          // updatedViewModelはOptionalのためnilチェック
          guard let _ = updatedViewModel else {
            print("updatedViewModel is nil")
            return
          }
          
          self.viewModel = updatedViewModel
          self.tableView.reloadData()
        }
      }
    }
  }
  
  // viewModelの値を更新する
  private func updateViewModel(json: [String: Any]?) {
    viewModel.updatePagesViewModel(json: json) { (updatedViewModel) in
      
      // updatedViewModelはOptionalのためnilチェック
      guard let _ = updatedViewModel else {
        print("updatedViewModel is nil")
        return
      }
      
      self.viewModel = updatedViewModel
      self.tableView.reloadData()
    }
  }
  
  // NotificationCenterへの通知登録を行う
  private func addObserver() {
    center.addObserver(self, selector: #selector(self.notified(notification:)),
                       name: .viewModelUpdateNotification, object: nil)
  }
  
  // NotificationCenterからの通知解除を行う
  private func removeObserver() {
    // NotificationCenterに登録されているすべての通知を解除
    center.removeObserver(self)
  }
  
  @objc private func notified(notification: Notification) {
    // userInfoはOptional型
    if let userInfo = notification.userInfo {
      //updateViewModel(json: (userInfo as NSDictionary?) as! [String : Any]?)
      updateViewModel(json: userInfo as? [String : Any])
    }
  }

}

// クラス外からも使用できるようにNSNotification.Nameを拡張
extension NSNotification.Name {
  static let viewModelUpdateNotification = NSNotification.Name("viewModelUpdateNotification")
}
