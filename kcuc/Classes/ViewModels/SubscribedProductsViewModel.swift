//
//  SubscribedProductsViewModel.swift
//  kcuc
//
//  Created by Yuki on 2017/03/23.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import Foundation
import CocoaLumberjack
import ObjectMapper

class SubscribedProductsViewModel: Mappable {
  /// 購読済み製品
  var products: [Product] = []
  
  private init() { }
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    products <- map["subscribedProducts"]
  }
  
  class func initiate(with name: String,
                      completion: ((SubscribedProductsViewModel?, Error?) -> Void)?) {
    let parameters: [String: String] = ["user": name]
    
    APIClient.request(with: .get, path: "/check/products", parameters: parameters) { (json, error) in
      if let _ = error {
        completion?(nil, error)
        
        return
      }
      
      guard let json = json?.dictionaryObject else {
        completion?(nil, nil)
        return
      }
      
      let viewModel = Mapper<SubscribedProductsViewModel>().map(JSON: json)
      
      completion?(viewModel, nil)
    }
  }
}
