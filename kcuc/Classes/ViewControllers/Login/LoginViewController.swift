//
//  LoginViewController.swift
//  kcuc
//
//  Created by Yuki on 2017/01/22.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjack

class LoginViewController: UIViewController {
  @IBOutlet weak var userIdInputArea: UITextField!
  
  @IBAction func didPressLoginButton(_ sender: UIButton) {
    guard let userId = userIdInputArea.text, userId.characters.count > 0 else {
      let alert = UIAlertController(title: "エラー",
                                    message: "ユーザー名が未入力です",
                                    preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
      
      return
    }
    
    // UserDefaultsは軽易なデータを保管する方法として活用されるケースが多いとのこと
    // Swift3.0からRenameされた(以前はNSUserDefaults)が、bridgeされているため同様に扱える
    UserDefaults.standard.set(userId, forKey: "kcuc.userId")
    UserDefaults.standard.synchronize()
    
    dismiss(animated: true, completion: nil)
  }
}
