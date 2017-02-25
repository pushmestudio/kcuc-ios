//
//  SearchedProductsViewModel.swift
//  kcuc
//
//  Created by meltest on 2017/02/23.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import ObjectMapper

// kcucへの検索結果を受け取るクラス
class SearchedProductsViewModel: Mappable {
    var offset: Int!
    var next: Int!
    var prev: Int!
    var count: Int!
    var total: Int!
    var code: Int!
    var topics: [Topic] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        offset <- map["offset"]
        next <- map["next"]
        prev <- map["prev"]
        count <- map["count"]
        total <- map["total"]
        code <- map["code"]
        topics <- map["topics"]
    }
    
    class func initialize(with parameters: [String: Any]?,
                          handler: ((_ viewModel: SearchedProductsViewModel?, _ error: Error?)-> Void)?) {
        APIClient.request(with: .get, path: "/search/pages", parameters: parameters) { (result, error) in
            if let error = error {
                handler?(nil, error)
            }
            
            let json = result!.dictionaryObject!
            // print(json)
            let viewModel = Mapper<SearchedProductsViewModel>().map(JSON: json)
            handler?(viewModel, nil)
        }
    }
}
