//
//  PageViewController.swift
//  kcuc
//
//  Created by Yuki on 2017/02/06.
//  Copyright © 2017 Pushme Studio. All rights reserved.
//

import Foundation
import WebKit
import CocoaLumberjackSwift

class PageViewController: UIViewController {
  // MARK:Pproperties
  private let url: URL
  private let href: String // urlはinitのときにURIになってしまうので、パスだけを保存しておく
  private let webView: WKWebView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
  
  var viewModel: SubscribeViewModel!
  
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
    
    // "add(+)"buttonを追加.storyboardでwebviewのsceneが作成されていないのでプログラム的に追加している
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(subscribePage))
    navigationItem.rightBarButtonItem = addButton
    
    webView.frame = view.bounds
    webView.backgroundColor = UIColor.white
    webView.navigationDelegate = self
    view.addSubview(webView)
    
    DDLogDebug("url: \(url.absoluteString)")
    
    let request = URLRequest(url: url)
    webView.load(request)
  }
    
  func subscribePage() {
    print("tap add button")
    // userIdをUserDefaultsから取得(objectとして保存されている？のでStringにdowncast)
    guard let userId = UserDefaults.standard.object(forKey: "kcuc.userName") as? String else { return }
    let pagesParameters: [String: Any] = [ "user": userId, "href": href ]
    print("userId = \(userId), href = \(href)")
    print(pagesParameters)
    
    // APIからの返り値を画面に表示する必要はないので、viewModelは不要？
    SubscribeViewModel.initialize(with: pagesParameters){ (viewModel, error) in
      if let _ = error {
        print("init error")
        return
      }
      
      self.viewModel = viewModel
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
  }
}
