//
//  SubscribedPagesViewController.swift
//  kcuc
//
//  Created by Yuki on 2016/12/25.
//  Copyright © 2016 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift
import SVProgressHUD

class SubscribedPagesViewController: UITableViewController {
  private var viewModel: PagesViewModel!
  private var isNeedUpdate: Bool = false
  var product: String!
  
  // MARK: Actions
  @IBAction func changeEditMode(_ sender: Any) {
    if self.tableView.isEditing {
      self.tableView.isEditing = false
    } else {
      self.tableView.isEditing = true
    }
  }
  
  // UITableViewControllerのsubclassで正しくinitializeを行う方法が曖昧…
  required init?(coder aDecoder: NSCoder) {
    //fatalError("init(coder:) has not been implemented")
    super.init(coder: aDecoder)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handlePageSubsribeNotification(_:)),
                                           name: .pageSubscribeNotification,
                                           object: nil)
  }

  deinit {
    // Remove all observers
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.addBackButton()
    
    // 引っ張って更新のアレを追加
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self,
                              action: #selector(initiateViewModel),
                              for: .valueChanged)
    
    // viewDidLoadはViewController生成時に一度だけ呼ばれるのでここで呼ぶ
    initiateViewModel()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if isNeedUpdate {
      initiateViewModel()
    }
  }
  
  @objc private func handlePageSubsribeNotification(_ notification: Notification) {
    DDLogDebug("Notification: Received page subscribe notification")
    
    isNeedUpdate = true
  }

  
  @objc private func initiateViewModel() {
    guard let userId = UserDefaults.standard.string(forKey: "kcuc.userId") else {
      refreshControl?.endRefreshing()
      return
    }
    
    SVProgressHUD.show()
    
    let parameters: [String: Any] = [ "user": userId, "product": product ]
    
    PagesViewModel.initialize(with: parameters) { (viewModel, error) in
      SVProgressHUD.dismiss()
      
      self.refreshControl?.endRefreshing()
      
      if let _ = error {
        return
      }
      
      self.viewModel = viewModel
      self.tableView.reloadData()
      
      self.isNeedUpdate = false
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
        
        // editモードを終了する
        self.tableView.isEditing = false
        // viewを更新(kcucから最新のデータ取得)
        self.initiateViewModel()
        
        // viewModel.subscribedPagesが0になったらsubscribedProductsページに戻る
        let pageCount = self.viewModel.subscribedPages.count
        if pageCount <= 0 {
          self.performSegue(withIdentifier: "unwindToSubscribedProducts", sender: self)
        }
      }
    }
  }

}

// クラス外からも使用できるようにNSNotification.Nameを拡張
extension NSNotification.Name {
  /// ページ購読
  static let pageSubscribeNotification = NSNotification.Name("kcuc.pageSubsribeNotification")
}
