//
//  Page.swift
//  kcuc
//
//  Created by Yuki on 2016/12/28.
//  Copyright © 2016 Pushme Studio. All rights reserved.
//

import ObjectMapper

struct Page: Mappable {
  var isUpdated: Bool = false
  var pageHref: URL?
  var prodName: String!
  var userId: String!
  var updatedTime: Date?
  
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    isUpdated <- map["isUpdated"]
    pageHref <- (map["pageHref"], URLTransform())
    prodName <- map["prodName"]
    userId <- map["userId"]
    updatedTime <- (map["updatedTime"], UnixDateTransform())
  }
}

// 修飾子のDefaultはinternal(同一モジュールからのアクセス許可)
class UnixDateTransform: TransformType {
  typealias Object = Date
  typealias JSON = String
  
  func transformFromJSON(_ value: Any?) -> Date? {
    guard let value = value as? String, let unixts: Int64 = Int64(value) else { return nil }
    
    let timeInterval: Double = Double(unixts / 1000) + Double(unixts % 1000)
    
    return Date(timeIntervalSince1970: TimeInterval(timeInterval))
  }
  
  func transformToJSON(_ value: Date?) -> String? {
    return "\(value?.timeIntervalSince1970 ?? 0)"
  }
}
