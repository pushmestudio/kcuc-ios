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
  
  func set(page:Page) {
    titleLabel.text = page.prodName
  }
}
