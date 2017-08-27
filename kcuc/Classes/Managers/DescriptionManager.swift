//
//  DescriptionManager.swift
//  kcuc
//
//  Created by meltest on 2017/03/01.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import SwiftyJSON
import CocoaLumberjack

class DescriptionManager {
  
  // クラスメソッドの指定にはclassとstaticがあるが、staticは継承先でoverrideできない
  // completionHandlerについて、クロージャを非同期に実行する場合やスコープ外から強参照される場合は@escapingが必要
  // 今回はクロージャがすぐに実行されるため@escapingは不要
  class func subscribePage(user: String,
                           href: String,
                           completionHandler: (([String: Any]?, Error?) -> Void)? = nil) {
    let parameters: [String: String] = ["user": user, "href": href]
    APIClient.request(with: .post, path: "/check/pages", parameters: parameters) { (result, error) in
      // nilの判定 + unwrap (if let _ = error でもnilの判定は可能だが、if文中でerrorはOptionalのままとなる）
      if let error = error {
        DDLogDebug("Error: \(error.localizedDescription)")
        completionHandler?(nil, error)
      }
      
      let json = result!.dictionaryObject!
      completionHandler?(json, nil)
    }
  }
  
  // ページの購読解除
  class func unSubscribePage(user: String,
                             href: String,
                             completionHandler: (([String: Any]?, Error?) -> Void)? = nil) {
    let parameters: [String: String] = ["user": user, "href": href]
    APIClient.request(with: .put, path: "/check/pages", parameters: parameters) { (result, error) in
      // nilの判定 + unwrap (if let _ = error でもnilの判定は可能だが、if文中でerrorはOptionalのままとなる）
      if let error = error {
        DDLogDebug("Error: \(error.localizedDescription)")
        completionHandler?(nil, error)
      }
      
      let json = result!.dictionaryObject!
      completionHandler?(json, nil)
    }
  }
  
  // 製品一括の購読解除
  class func unSubscribeProduct(user: String,
                             product: String,
                             completionHandler: (([String: Any]?, Error?) -> Void)? = nil) {
    let parameters: [String: String] = ["user": user, "product": product]
    APIClient.request(with: .put, path: "/check/products", parameters: parameters) { (result, error) in
      // nilの判定 + unwrap (if let _ = error でもnilの判定は可能だが、if文中でerrorはOptionalのままとなる）
      if let error = error {
        DDLogDebug("Error: \(error.localizedDescription)")
        completionHandler?(nil, error)
      }
      
      let json = result!.dictionaryObject!
      completionHandler?(json, nil)
    }
  }
}
