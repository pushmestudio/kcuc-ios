//
//  SubscribedPageCell.swift
//  kcuc
//
//  Created by meltest on 2017/04/27.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class SearchedProductCell: UITableViewCell {
  @IBOutlet weak var pageName: UILabel!
  @IBOutlet weak var productLabel: UILabel!
  
  func set(topic: Topic) {
    // KCではhtmlで表示する関係上タグが含まれているものがあるので、削除
    let pageNameWithoutTags = topic.label?.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    
    // 製品名を取得(未使用).kcucからの返りが配列であるため、productsは配列で受け取る必要がありそう
    let product = topic.products
    let productName = product[0].label
    
    pageName.text = pageNameWithoutTags
    productLabel.text = productName
  }
}
