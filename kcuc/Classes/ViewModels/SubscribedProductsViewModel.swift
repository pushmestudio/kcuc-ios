//
//  SubscribedProductsViewModel.swift
//  kcuc
//
//  Created by Yuki on 2017/03/23.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift
import ObjectMapper

class SubscribedProductsViewModel {
  /// 購読済み製品
  var products: [Product] = []
  
  private init() { }
  
  class func initiate(with name: String,
                      completion: ((SubscribedProductsViewModel?, Error?) -> Void)?) {
    let parameters: [String: String] = ["user": name]
    
    APIClient.request(with: .get, path: "/check/products", parameters: parameters) { (json, error) in
      if let _ = error {
        completion?(nil, error)
        
        return
      }
      
      // 一覧の配列構造的にObjectMapperが使用できないため自力
      let products = json!["subscribedProducts"].dictionaryObject as! [String: String]
      
      let viewModel: SubscribedProductsViewModel = SubscribedProductsViewModel()
      viewModel.products = products.map { Product(href: $0, label: $1) }
      
      completion?(viewModel, nil)
    }
  }
}
