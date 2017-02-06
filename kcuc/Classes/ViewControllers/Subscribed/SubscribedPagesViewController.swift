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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let navigationButton = UIBarButtonItem()
    navigationButton.title = "戻る"
    navigationItem.backBarButtonItem = navigationButton
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if viewModel == nil {
      guard let userName = UserDefaults.standard.object(forKey: "kcuc.userName") as? String else { return }
      
      let pagesParameters: [String: Any] = [ "user": userName ]
      
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
}
