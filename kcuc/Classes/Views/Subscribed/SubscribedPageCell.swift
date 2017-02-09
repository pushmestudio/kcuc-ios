//
//  SubscribedPageCell.swift
//  kcuc
//
//  Created by Yuki on 2017/01/22.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class SubscribedPageCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var updateDateLabel: UILabel!
  
  func set(page: Page) {
    titleLabel.text = page.prodName
    
    if let date = page.updatedTime {
      let dateFormatter: DateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
      
      let formattedDate = dateFormatter.string(from: date)
      
      updateDateLabel.text = "Updated: \(formattedDate)"
    }
  }
}
