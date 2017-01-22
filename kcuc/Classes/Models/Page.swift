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
  var prodId: String!
  var updatedTime: UInt?
  
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    isUpdated <- map["isUpdated"]
    pageHref <- (map["pageHref"], URLTransform())
    prodId <- map["prodId"]
    updatedTime <- map["updatedTime"]
  }
}
