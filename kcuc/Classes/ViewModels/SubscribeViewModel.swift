//
//  SubscribeViewModel.swift
//  kcuc
//
//  Created by meltest on 2017/02/28.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import ObjectMapper
import CocoaLumberjackSwift

class SubscribeViewModel: Mappable {
  var subscribedPages: [Page] = []
  var userId: String = ""
  var code: Int = 0
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    subscribedPages <- map["subscribedPages"]
    userId <- map["userId"]
    code <- map["code"]
  }
  
  class func initialize(with parameters: [String: Any]?,
                        handler: ((_ viewmodel: SubscribeViewModel?, Error?)-> Void)?) {
    APIClient.request(with: .post, path: "/check/pages", parameters: parameters) { (result, error) in
      if let error = error {
        handler?(nil, error)
      }
      
      let json = result!.dictionaryObject!
      print(json)
      
      let viewModel = Mapper<SubscribeViewModel>().map(JSON: json)
      handler?(viewModel, nil)
    }
  }
}
