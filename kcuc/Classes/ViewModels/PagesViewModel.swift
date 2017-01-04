//
//  PagesViewModel.swift
//  kcuc
//
//  Created by Yuki on 2017/01/04.
//  Copyright © 2017 Pushme Studio. All rights reserved.
//

import ObjectMapper

class PagesViewModel: Mappable {
  var id: String = ""
  var pages: [Page] = []
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    id <- map["id"]
    pages <- map["pages"]
  }
  
  class func initialize(with parameters: [String: Any]?,
                        handler: ((_ viewModel: PagesViewModel?, _ error: Error?)-> Void)?) {
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
