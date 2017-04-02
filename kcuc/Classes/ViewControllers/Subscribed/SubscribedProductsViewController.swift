//
//  SubscribedProductsViewController.swift
//  kcuc
//
//  Created by Yuki on 2017/03/23.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift
import SVProgressHUD

class SubscribedProductsViewController: UITableViewController {
  /// ViewModel
  private var viewModel: SubscribedProductsViewModel!
  private var isNeedUpdate: Bool = false
  
  // MARK: Actions
  @IBAction func changeEditMode(_ sender: Any) {
    if self.tableView.isEditing {
      self.tableView.isEditing = false
    } else {
      self.tableView.isEditing = true
    }
  }
  
  // unwind segue 本来ならここでisNeedUpdateをtrueにして項目がなくなった製品も見えなくなるようにしたいのだが上手くいかない
  @IBAction func unwindToSubscribedProducts(segue: UIStoryboardSegue) {}
  
  deinit {
    // Remove all observers
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 戻るボタン設定
    // (設定しないとタイトル名がボタン名になる)
    navigationItem.addBackButton()
    
    // 引っ張って更新するアレ
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self,
                              action: #selector(initiateViewModel),
                              for: .valueChanged)
    
    // ViewModel生成
    initiateViewModel()
    
    // Add observer
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handlePageSubsribeNotification(_:)),
                                           name: .pageSubscribeNotification,
                                           object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if isNeedUpdate {
      initiateViewModel()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // ログイン画面から遷移してきたとき、ViewModelを生成
    if viewModel == nil {
      initiateViewModel()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case "subsribedProducts.pages":
      let viewController = segue.destination as? SubscribedPagesViewController
      let indexPath = sender as! IndexPath
      
      let product: Product = viewModel.products[indexPath.row]
      
//      viewController?.product = product.href?.absoluteString ?? ""
      viewController?.product = product.href ?? ""
      viewController?.title = product.label
      
    default:
      break
    }
  }
  
  @objc private func handlePageSubsribeNotification(_ notification: Notification) {
    DDLogDebug("Notification: Received page subscribe notification")
    
    isNeedUpdate = true
  }
  
  @objc private func initiateViewModel() {
    guard let user = UserDefaults.standard.object(forKey: "kcuc.userId") as? String else { return }
    
    SVProgressHUD.show()
    
    SubscribedProductsViewModel.initiate(with: user) { [weak self] (viewModel, error) in
      SVProgressHUD.dismiss()
      
      guard let weakSelf = self else { return }
      
      weakSelf.refreshControl?.endRefreshing()
      
      if let error = error {
        DDLogDebug("Error: \(error.localizedDescription)")
        
        return
      }
      
      weakSelf.viewModel = viewModel
      weakSelf.tableView.reloadData()
      
      weakSelf.isNeedUpdate = false
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.products.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell",
                                             for: indexPath)
    
    let product: Product = viewModel.products[indexPath.row]
    cell.textLabel?.text = product.label
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "subsribedProducts.pages", sender: indexPath)
  }
  
  // cellを削除可能にする
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // Deleteが押されたらcellを削除する
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete {
      guard let userId = UserDefaults.standard.object(forKey: "kcuc.userId") as? String else { return }
      let product = viewModel.products[indexPath.row].href
      // Cloudantから該当のページを削除し、削除後のsubscribeProducts一覧を受け取る
      DescriptionManager.unSubscribeProduct(user: userId, product: product!){ (result, error) in
        // nilチェック
        if let _ = error {
          DDLogDebug("Error: \(error?.localizedDescription)")
          return
        } else if result!["code"] as! Int != 200 {
          // subscribePageの結果は失敗でもJSONで返ってくるので、中身のステータスコードをチェックしておく
          print(result!["detail"] as! String)
          return
        } else {
          print("unsubscribed product")
        }
        
        // editモードを終了する
        self.tableView.isEditing = false
        // viewを更新(kcucから最新のデータ取得)
        self.initiateViewModel()
      }
    }
  }

}
