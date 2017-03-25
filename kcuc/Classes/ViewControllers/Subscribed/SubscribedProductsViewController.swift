//
//  SubscribedProductsViewController.swift
//  kcuc
//
//  Created by Yuki on 2017/03/23.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class SubscribedProductsViewController: UITableViewController {
  /// ViewModel
  private var viewModel: SubscribedProductsViewModel!
  
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
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case "subsribedProducts.pages":
      let viewController = segue.destination as? SubscribedPagesViewController
      let indexPath = sender as! IndexPath
      
      let product: Product = viewModel.products[indexPath.row]
      
      viewController?.product = product.href?.absoluteString ?? ""
      
    default:
      break
    }
  }
  
  @objc private func initiateViewModel() {
    guard let user = UserDefaults.standard.object(forKey: "kcuc.userId") as? String else { return }
    
    SubscribedProductsViewModel.initiate(with: user) { [weak self] (viewModel, error) in
      guard let weakSelf = self else { return }
      
      weakSelf.refreshControl?.endRefreshing()
      
      if let error = error {
        DDLogDebug("Error: \(error.localizedDescription)")
        
        return
      }
      
      weakSelf.viewModel = viewModel
      weakSelf.tableView.reloadData()
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
}