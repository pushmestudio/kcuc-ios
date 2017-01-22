//
//  MainTabBarController.swift
//  kcuc
//
//  Created by Yuki on 2017/01/22.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class MainTabBarController: UITabBarController {
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let userName = UserDefaults.standard.object(forKey: "kcuc.userName") as? String {
      DDLogDebug("login as \(userName)")
    } else {
      performSegue(withIdentifier: "showLoginModal", sender: nil)
    }
  }
}
