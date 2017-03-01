//
//  DescriptionManager.swift
//  kcuc
//
//  Created by 冨田貴之 on 2017/03/01.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import SwiftyJSON

class DescriptionManager {
  
  // クラスメソッドの指定にはclassとstaticがあるが、staticは継承先でoverrideできない
  // completionHandlerについてはSwift3.0からパラメータの前に@escapeを付ける仕様になったという理解でよい？
  class func subscribePage(user: String,
                           href: String,
                           completionHandler: @escaping ([String: Any]?, Error?) -> Void){
    let parameters: [String: Any] = ["user": user, "href": href]
    APIClient.request(with: .post, path: "/check/pages", parameters: parameters) { (result, error) in
      if let error = error {
        print(error)
        completionHandler(nil, error)
      }
      
      let json = result!.dictionaryObject!
      completionHandler(json, nil)
      
      // TODO: 結果をSubscribedPageViewControllerに渡してviewModelを更新する
      /*
       let viewModel = Mapper<SearchedProductsViewModel>().map(JSON: json)
       handler?(viewModel, nil)
       */
    }
    
  }
}
