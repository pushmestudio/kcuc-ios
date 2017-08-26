//
//  DDLogFormatterExtension.swift
//  kcuc
//
//  Created by Yuki on 2017/01/20.
//  Copyright © 2017年 Pushme Studio. All rights reserved.
//

import Foundation
import CocoaLumberjack

class KCUCLogFormatter: NSObject, DDLogFormatter {
  let dateFormatter: DateFormatter = DateFormatter()
  
  override init() {
    super.init()
    
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
  }
  
  func format(message logMessage: DDLogMessage) -> String? {
    let logLevel: String
    switch logMessage.flag {
    case DDLogFlag.error:
      logLevel = "ERROR"
    case DDLogFlag.warning:
      logLevel = "WARNING"
    case DDLogFlag.info:
      logLevel = "INFO"
    case DDLogFlag.debug:
      logLevel = "DEBUG"
    default:
      logLevel = "VERBOSE"
    }
    
    let dt = dateFormatter.string(from: logMessage.timestamp)
    let logMsg = logMessage.message
    let lineNumber = logMessage.line
    let file = logMessage.fileName
    let functionName = logMessage.function
    let threadId = logMessage.threadID
    
    return "\(dt) [\(threadId)] [\(logLevel)] [\(file):\(lineNumber)]\(functionName) - \(logMsg)"
  }
}
