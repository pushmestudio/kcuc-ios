//
//  PagesViewModel.swift
//  kcuc
//
//  Created by Yuki on 2017/01/04.
//  Copyright © 2017 Pushme Studio. All rights reserved.
//

import ObjectMapper
import CocoaLumberjack

class PagesViewModel: Mappable {
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
                        handler: ((PagesViewModel?, Error?)-> Void)?) {
    APIClient.request(with: .get, path: "/check/pages", parameters: parameters) { (result, error) in
      if let error = error {
        handler?(nil, error)
      }
      
      let json = result!.dictionaryObject!
      
      let viewModel = Mapper<PagesViewModel>().map(JSON: json)
      handler?(viewModel, nil)
    }
  }
  
}
