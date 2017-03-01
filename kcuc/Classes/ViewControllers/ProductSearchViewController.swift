//
//  ProductSearchViewController.swift
//  kcuc
//
//  Created by meltest on 2017/02/23.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class ProductSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  // MARK:Pproperties
  var viewModel: SearchedProductsViewModel!
  
  @IBOutlet weak var searchTextField: UITextField!        // 検索box
  @IBOutlet weak var searchResultTableView: UITableView!  // 検索結果表示用のtableview
  
  // MARK: Actions
  @IBAction func searchProdctButton(_ sender: UIButton) {
    guard let query = searchTextField.text else { return }
    let pagesParameters: [String: Any] = [ "query": query ]
    
    // ViewModelのinitializeの結果をclosureで受け取っている? handlerの指定がないのがよくわからない
    SearchedProductsViewModel.initialize(with: pagesParameters){ (viewModel, error) in
      if let _ = error {
        print("init error")
        return
      }
      
      self.viewModel = viewModel
      self.searchResultTableView.reloadData()
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* 今回はstoryboardで繋いでいるため記述不要
     searchResultTableView.delegate = self
     searchResultTableView.dataSource = self
     */
    
    self.searchResultTableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // viewModelはImplicity Unwrapped Optionalなので仮にnilだった場合クラッシュする
    // そのため、あえてOptionalにしてデフォルト値を設けることで、エラーを防止している？
    return viewModel?.topics.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedProductCell", for: indexPath)
    
    let topic = viewModel.topics[indexPath.row]
    // ページ名を取得
    let pageName = topic.label
    // 製品名を取得(未使用).kcucからの返りが配列であるため、productsは配列で受け取る必要がありそう
    // let product = topic.products
    // let productName = product[0].label
    
    // KCではhtmlで表示する関係上タグが含まれているものがあるので、削除
    let pageNameWithoutTags = pageName?.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    
    cell.textLabel?.text = pageNameWithoutTags
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let topic = viewModel.topics[indexPath.row]
    
    DDLogDebug("href: \(topic.href?.absoluteString ?? "no referrer")")
    
    if let absoluteString = topic.href?.absoluteString {
      let viewController = PageViewController(url: absoluteString)
      
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
}
