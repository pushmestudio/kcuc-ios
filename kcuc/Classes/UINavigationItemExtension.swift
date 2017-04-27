//
//  UINavigationItemExtension.swift
//  kcuc
//
//  Created by Yuki on 2017/03/24.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import UIKit

extension UINavigationItem {
  /**
   * NaviationBarに戻るボタンを設定
   */
  func addBackButton() {
    let navigationButton = UIBarButtonItem()
    navigationButton.title = "back"
    self.backBarButtonItem = navigationButton
  }
}
