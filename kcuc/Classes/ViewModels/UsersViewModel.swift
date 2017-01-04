//
//  UsersViewModel.swift
//  kcuc
//
//  Created by Yuki on 2016/12/28.
//  Copyright © 2016 Pushme Studio. All rights reserved.
//

import ObjectMapper

class UsersViewModel: Mappable {
  var users: [User] = []
  var pageHref: String = ""
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    users <- map["userList"]
    pageHref <- map["pageHref"]
  }
  
  class func initialize(with parameters: [String: Any]?,
                        handler: ((_ viewModel: UsersViewModel?, _ error: Error?)-> Void)?) {
    APIClient.request(with: .get, path: "/check/users", parameters: parameters) { (result, error) in
      if let error = error {
        handler?(nil, error)
      }
      
      let json = result!.dictionaryObject!
      
      let viewModel = Mapper<UsersViewModel>().map(JSON: json)
      handler?(viewModel, nil)
    }
  }
}
