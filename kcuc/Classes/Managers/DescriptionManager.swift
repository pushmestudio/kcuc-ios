//
//  DescriptionManager.swift
//  kcuc
//
//  Created by meltest on 2017/03/01.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import SwiftyJSON

class DescriptionManager {
  
  // クラスメソッドの指定にはclassとstaticがあるが、staticは継承先でoverrideできない
  // completionHandlerについてはSwift3.0からパラメータの前に@escapingを付ける仕様になったという理解でよい？
  class func subscribePage(user: String,
                           href: String,
                           completionHandler: @escaping ([String: Any]?, Error?) -> Void){
//                           completionHandler: (([String: Any]?, Error?) -> Void)? = nil){
    let parameters: [String: Any] = ["user": user, "href": href]
    APIClient.request(with: .post, path: "/check/pages", parameters: parameters) { (result, error) in
      if let _ = error {
        print(error ?? "some API problem occured")
        completionHandler(nil, error)
      }
      
      let json = result!.dictionaryObject!
      completionHandler(json, nil)
      
    }
    
  }
}
