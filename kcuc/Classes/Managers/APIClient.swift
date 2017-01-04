//
//  APIClient.swift
//  kcuc
//
//  Created by Yuki on 2016/12/27.
//  Copyright © 2016 Pushme Studio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let basePath = "https://kcuc.mybluemix.net/api"

class APIClient {
  /**
   * APIリクエスト
   *
   * - parameter method: メソッド
   * - parameter path: base以下のパス
   * - parameter parameters: リクエスト時に付与するパラメータ
   * - parameter handler: 処理完了後のハンドラ
   */
  class func request(with method: HTTPMethod,
                     path: String,
                     parameters: [String: Any]?,
                     handler: ((_ result: JSON?, _ error: Error?) -> Void)?) {
    
    // TODO: add base parameters if needed
    var requestParameters: [String: Any] = [:]
    
    if let parameters = parameters {
      for param in parameters {
        requestParameters[param.key] = param.value
      }
    }
    
    Alamofire.request(basePath + path,
                      method: method,
                      parameters: requestParameters,
                      headers: nil).responseJSON { response in
                        
                        if let error = response.result.error {
                          handler?(nil, error)
                          
                          return
                        }
                        
                        var json: JSON?
                        
                        if let data = response.data {
                          json = JSON(data: data)
                        }
                        
                        handler?(json, nil)
                  
    }
  }
}
