//
//  MainTabBarController.swift
//  kcuc
//
//  Created by Yuki on 2017/01/22.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjack

class MainTabBarController: UITabBarController {
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let userId = UserDefaults.standard.object(forKey: "kcuc.userId") as? String {
      DDLogDebug("login as \(userId)")
    } else {
      performSegue(withIdentifier: "showLoginModal", sender: nil)
    }
  }
}
