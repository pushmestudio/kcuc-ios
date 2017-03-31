//
//  SearchedProduct.swift
//  kcuc
//
//  Created by meltest on 2017/02/23.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

// ObjectMapper is a framework that makes it easy for you to convert your model objects (classes and structs) to and from JSON
import ObjectMapper

/*
 --- JSON → model objectへの変換 ---
 let result = SearchedProduct(JSONString: JSONString)
 --- model object → JSONへの変換 ---
 let JSONString = result.toJSONString(prettyPrint: true)
 */

struct Topic: Mappable {
  var date: Date?
  var href: URL?
  var label: String!
  var summary: String!
  var products: [Product] = []
  // var products: [String : AnyObject] = [:] //AnyObjectは関数や構造体を受入れないが、Anyは受入可能
  
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    // map <=> JSONの紐付け
    date <- (map["date"], UnixMilliSecondsDateTranfrom())
    href <- (map["href"], URLTransform())
    label <- map["label"]
    summary <- map["summary"]
    products <- map["products"]
  }
}
