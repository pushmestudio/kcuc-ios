//
//  PageViewController.swift
//  kcuc
//
//  Created by Yuki on 2017/02/06.
//  Copyright © 2017 Pushme Studio. All rights reserved.
//

import Foundation
import WebKit
import CocoaLumberjack
import SVProgressHUD

class PageViewController: UIViewController {
  // MARK:Pproperties
  private let url: URL
  private let href: String // urlはinitのときにURIになってしまうので、パスだけを保存しておく
  private let webView: WKWebView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
  
  init(url: String) {
    self.href = url
    self.url = URL(string: "http://www.ibm.com/support/knowledgecenter/" +  url)!
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "IBM Knowledge Center"
    
    webView.frame = view.bounds
    webView.backgroundColor = UIColor.white
    webView.navigationDelegate = self
    view.addSubview(webView)
    
    // "add(+)"buttonを作成.storyboardでwebviewのsceneが作成されていないのでプログラム的に追加している
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(subscribePage))
    let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "iconExtarnal"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(copyURL))
    // navigationBarに2つのボタンを表示するため一時的に配列化
    navigationItem.setRightBarButtonItems([addButton, rightButton], animated: true)
    navigationItem.rightBarButtonItems![1].isEnabled = false
    
    DDLogDebug("url: \(url.absoluteString)")
    
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    SVProgressHUD.dismiss()
  }
  
  @objc private func copyURL() {
    guard let urlString = webView.url?.absoluteString else { return }
    
    UIPasteboard.general.string = urlString
    
    let alert: UIAlertController = UIAlertController(title: nil, message: "URLをコピーしました", preferredStyle: .alert)
    let confirm: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(confirm)
    
    present(alert, animated: true)
  }
  
  // ページを購読する
  // 通常であればクラス内でしか使用されないためprivateをつけるだけでよいが、Objective-Cの機能である#selectorで呼び出されるため@objcも指定する
  // Obective-CからはsubscribePageに対して参照許可がないためであり、これを許可するために必要である
  @objc private func subscribePage() {
    // userIdをUserDefaultsから取得.Stringとして取得すれば良いため"UserDefaults.sring(forKey:)を使用"
    guard let user = UserDefaults.standard.string(forKey: "kcuc.userId") else { return }
    
    SVProgressHUD.show()
    
    DescriptionManager.subscribePage(user: user, href: href){ (result, error) in
      SVProgressHUD.dismiss()
      
      // nilチェック
      if let _ = error {
        DDLogDebug("Error: \(error?.localizedDescription)")
        return
      } else if result!["code"] as! Int != 201 {
        // subscribePageの結果は失敗でもJSONで返ってくるので、中身のステータスコードをチェックしておく
        DDLogDebug(result!["detail"] as! String)
        return
      } else {
        DDLogDebug("subscribed new page")
      }
      
      SVProgressHUD.showSuccess(withStatus: "Subscribed！")
      SVProgressHUD.dismiss(withDelay: 1.0)
      
      // NotificationCenterを通してSubscribedPagesViewControllerに通知とsubscribePageの返り値を送信
      NotificationCenter.default.post(name: .pageSubscribeUpdateNotification, object: nil, userInfo: result)

    }
  }
}

extension PageViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    DDLogDebug("\(webView.url?.absoluteString)")
    
    decisionHandler(.allow)
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    DDLogDebug("Error: \(error.localizedDescription)")
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if let title = webView.title {
      self.title = title.replacingOccurrences(of: "IBM Knowledge Center - ", with: "")
    }
    
    navigationItem.rightBarButtonItems![1].isEnabled = true
  }
}
