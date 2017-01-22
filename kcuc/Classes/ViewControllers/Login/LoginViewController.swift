//
//  LoginViewController.swift
//  kcuc
//
//  Created by Yuki on 2017/01/22.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class LoginViewController: UIViewController {
  @IBOutlet weak var userNameInputArea: UITextField!
  
  @IBAction func didPressLoginButton(_ sender: UIButton) {
    guard let userName = userNameInputArea.text, userName.characters.count > 0 else {
      let alert = UIAlertController(title: "エラー",
                                    message: "ユーザー名が未入力です",
                                    preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
      
      return
    }
    
    UserDefaults.standard.set(userName, forKey: "kcuc.userName")
    UserDefaults.standard.synchronize()
    
    dismiss(animated: true, completion: nil)
  }
}
