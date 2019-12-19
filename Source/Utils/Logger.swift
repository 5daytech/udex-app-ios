//
//  Logger.swift
//  UDEX
//
//  Created by Abai Abakirov on 12/19/19.
//  Copyright © 2019 MakeUseOf. All rights reserved.
//

class Logger {
  static let TAG = "logger"
  
  static func e(_ message: String, error: Error, tag: String = TAG) {
    print("\(tag): \(message) \(error)")
  }
  
  static func d(_ message: String, object: Any? = nil, tag: String = TAG) {
    print("\(tag): \(message) \(object ?? "")")
  }
}
