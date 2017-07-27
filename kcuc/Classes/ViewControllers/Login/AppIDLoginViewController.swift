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
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var hint: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let userId = UserDefaults.standard.object(forKey: "kcuc.userId") as? String {
      DDLogDebug("login as \(userId)")
      
      // UIApplication.shared.keyWindow?で現在最前面の画面のUIWindowを取得し、そのrootViewControllerを起点とする
      let mainView  = UIApplication.shared.keyWindow?.rootViewController
      let afterLoginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AfterLoginView") as? AfterLoginViewController
      
      mainView?.present(afterLoginView!, animated: true, completion: nil)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  class delegate : AuthorizationDelegate {
    public func onAuthorizationSuccess(accessToken: AccessToken, identityToken: IdentityToken, response:Response?) {
      // UIApplication.shared.keyWindow?で現在最前面の画面のUIWindowを取得し、そのrootViewControllerを起点とする
      let mainView  = UIApplication.shared.keyWindow?.rootViewController
      let afterLoginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AfterLoginView") as? AfterLoginViewController
      
      afterLoginView?.accessToken = accessToken
      afterLoginView?.idToken = identityToken
      
      /*
      let mainView  = UIApplication.shared.keyWindow?.rootViewController
      let afterLoginView  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AfterLoginView") as? AfterLoginViewController
      afterLoginView?.accessToken = accessToken
      afterLoginView?.idToken = identityToken
      
      afterLoginView?.selectHintMessage(prevAnon: (TokenStorageManager.sharedInstance.loadStoredToken() != nil), prevId: TokenStorageManager.sharedInstance.loadUserId(), currentAnon: accessToken.isAnonymous, currentId: accessToken.subject!)
      
      if accessToken.isAnonymous {
        TokenStorageManager.sharedInstance.storeToken(token: accessToken.raw)
      } else {
        TokenStorageManager.sharedInstance.clearStoredToken()
      }
      TokenStorageManager.sharedInstance.storeUserId(userId: accessToken.subject)
      
      */

      print("success")
      
      // OAUTH認証完了後、中継用のAfterLoginViewに遷移する
      DispatchQueue.main.async {
        mainView?.present(afterLoginView!, animated: true, completion: nil)
      }
    }
    
    public func onAuthorizationCanceled() {
      print("cancel")
    }
    
    public func onAuthorizationFailure(error: AuthorizationError) {
      print(error)
    }
  }
  
  @IBAction func log_in_anonymously(_ sender: AnyObject) {
    /*
    let token = TokenStorageManager.sharedInstance.loadStoredToken()
    
    AppID.sharedInstance.loginAnonymously(accessTokenString: token, authorizationDelegate: delegate())
    */
    AppID.sharedInstance.loginAnonymously(authorizationDelegate: delegate())
  }
  
  @IBAction func log_in(_ sender: AnyObject) {
    /*
    let token = TokenStorageManager.sharedInstance.loadStoredToken()
    AppID.sharedInstance.loginWidget?.launch(accessTokenString: token, delegate: delegate())
    */
    AppID.sharedInstance.loginWidget?.launch(delegate: delegate())
  }
}

