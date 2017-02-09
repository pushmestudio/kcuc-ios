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
  private let url: URL
  private let webView: WKWebView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
  
  init(url: String) {
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
    
    let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "iconExtarnal"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(copyURL))
    navigationItem.rightBarButtonItem = rightButton
    navigationItem.rightBarButtonItem!.isEnabled = false
    
    DDLogDebug("url: \(url.absoluteString)")
    
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
  @objc private func copyURL() {
    guard let urlString = webView.url?.absoluteString else { return }
    
    UIPasteboard.general.string = urlString
    
    let alert: UIAlertController = UIAlertController(title: nil, message: "URLをコピーしました", preferredStyle: .alert)
    let confirm: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(confirm)
    
    present(alert, animated: true)
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
    
    navigationItem.rightBarButtonItem!.isEnabled = true
  }
}
