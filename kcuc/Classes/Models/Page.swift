//
//  Page.swift
//  kcuc
//
//  Created by Yuki on 2016/12/28.
//  Copyright © 2016 Pushme Studio. All rights reserved.
//

import ObjectMapper

struct Page: Mappable {
  var pageHref: URL?
  var pageName: String!
  var isUpdated: Bool = false
  var updatedTime: Date?
  var prodId: String!
  var prodName: String!
  
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    pageHref <- (map["pageHref"], URLTransform())
    pageName <- map["pageName"]
    isUpdated <- map["isUpdated"]
    updatedTime <- (map["updatedTime"], UnixMilliSecondsDateTranfrom())
    prodId <- map["prodId"]
    prodName <- map["prodName"]
  }
}

// 修飾子のDefaultはinternal(同一モジュールからのアクセス許可)
class UnixMilliSecondsDateTranfrom: TransformType {
  typealias Object = Date
  typealias JSON = Double
  
  func transformFromJSON(_ value: Any?) -> Date? {
    if let timeInt = value as? Double {
      return Date(timeIntervalSince1970: TimeInterval(timeInt / 1000))
    }
    if let timeStr = value as? String {
      return Date(timeIntervalSince1970: TimeInterval(atof(timeStr) / 1000))
    }
    return nil
  }
  
  func transformToJSON(_ value: Date?) -> Double? {
    if let date = value {
      return Double(date.timeIntervalSince1970)
    }
    return nil
  }
}
