//
//  AfterLoginViewController.swift
//  kcuc
//
//  Created by meltest on 2017/07/25.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import BluemixAppID
import CocoaLumberjackSwift

// ログイン成功後に直接MainTabBarControllerに遷移する方法が思いつかなかったため、中継のViewControllerを用意している
class AfterLoginViewController: UIViewController {
  
  // IdentityTokenは、identity provider(google/facebook)にて認証されたユーザの情報をもつ
  var accessToken:AccessToken?
  var idToken:IdentityToken?
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let userId = idToken?.name ?? "Guest"
    print(idToken?.name ?? "Guest")
    print(idToken?.email ?? "Guest@example.com")
    
    // UserDefaultsは軽易なデータを保管する方法として活用されるケースが多いとのこと
    // Swift3.0からRenameされた(以前はNSUserDefaults)が、bridgeされているため同様に扱える
    UserDefaults.standard.set(userId, forKey: "kcuc.userId")
    UserDefaults.standard.synchronize()
    
    performSegue(withIdentifier: "AfterLoginSegue", sender: nil)
  }
}
