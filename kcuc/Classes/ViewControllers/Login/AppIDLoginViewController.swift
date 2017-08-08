//
//  AppIDLoginViewController.swift
//  kcuc
//
//  Created by meltest on 2017/07/20.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift
import BluemixAppID
import BMSCore

class AppIDLoginViewController: UIViewController {
  @IBAction func log_in(_ sender: AnyObject) {
    AppID.sharedInstance.loginWidget?.launch(delegate: self)
  }
}

extension AppIDLoginViewController: AuthorizationDelegate {
  public func onAuthorizationSuccess(accessToken: AccessToken, identityToken: IdentityToken, response:Response?) {
    // emailの情報をUserDefaultsに保存
    if let email = identityToken.email, email.characters.count > 0 {
      UserDefaults.standard.set(email, forKey: "kcuc.userId")
      UserDefaults.standard.synchronize()
    }
    
    DDLogDebug("Authorization success")
    
    // ViewControllerを閉じてTab画面へ戻る
    dismiss(animated: true)
  }
  
  // OAuth認証キャンセル時の処理
  public func onAuthorizationCanceled() {
    DDLogDebug("Authorization canceled")
  }
  
  // OAuth認証失敗時の処理
  public func onAuthorizationFailure(error: AuthorizationError) {
    DDLogDebug("Error: \(error.localizedDescription)")
  }
}

