//
//  AfterLoginViewController.swift
//  kcuc
//
//  Created by meltest on 2017/07/25.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

// ログイン成功後に直接MainTabBarControllerに遷移する方法が思いつかなかったため、中継のViewControllerを用意している
class AfterLoginViewController: UIViewController {
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    performSegue(withIdentifier: "AfterLoginSegue", sender: nil)
  }
}
