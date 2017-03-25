//
//  Product.swift
//  kcuc
//
//  Created by Yuki on 2017/03/23.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import Foundation
import ObjectMapper

struct Product: Mappable {
  /// ページのURL
  var href: URL?
  /// 製品名
  var label: String!
  
  // Mapperを介さず使用するため定義
  init(href: String, label: String) {
    self.href = URL(string: href)
    self.label = label
  }
  
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    // map <=> JSONの紐付け
    href <- (map["href"], URLTransform())
    label <- map["label"]
  }
}
