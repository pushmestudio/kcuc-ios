//
//  DescriptionManager.swift
//  kcuc
//
//  Created by meltest on 2017/03/01.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import SwiftyJSON
import CocoaLumberjackSwift

class DescriptionManager {
  
  // クラスメソッドの指定にはclassとstaticがあるが、staticは継承先でoverrideできない
  // completionHandlerについて、クロージャを非同期に実行する場合やスコープ外から強参照される場合は@escapingが必要
  // 今回はクロージャがすぐに実行されるため@escapingは不要
  class func subscribePage(user: String,
                           href: String,
                           completionHandler: (([String: Any]?, Error?) -> Void)? = nil) {
    let parameters: [String: String] = ["user": user, "href": href]
    APIClient.request(with: .post, path: "/check/pages", parameters: parameters) { (result, error) in
      if let _ = error {
        DDLogDebug("Error: \(error?.localizedDescription)")
        completionHandler?(nil, error)
      }
      
      let json = result!.dictionaryObject!
      completionHandler?(json, nil)
      
    }
    
  }
}
