//
//  FirstViewController.swift
//  kcuc
//
//  Created by Yuki on 2016/12/25.
//  Copyright © 2016 Pushme Studio. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
  
  var viewModel: UsersViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let parameters: [String: Any] = [ "href": "SSMTU9/welcometoibmverse.html" ]
    
    UsersViewModel.initialize(with: parameters) { (viewModel, error) in
      if let _ = error {
        return
      }
      
      self.viewModel = viewModel
      
      print("pageHref: \(viewModel?.pageHref)")
    }
    
    let pagesParameters: [String: Any] = [ "user": "tkhm" ]
    
    PagesViewModel.initialize(with: pagesParameters) { (viewModel, error) in
      if let _ = error {
        return
      }
      
      print("id: \(viewModel?.id)")
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
