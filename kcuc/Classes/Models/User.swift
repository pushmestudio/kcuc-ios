//
//  User.swift
//  kcuc
//
//  Created by Yuki on 2017/01/04.
//  Copyright © 2017 Pushme Studio. All rights reserved.
//

import ObjectMapper

struct User: Mappable {
  var id: String!
  var isUpdated: Bool = false
  
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    isUpdated <- map["isUpdated"]
  }
}
