//
//  Dictionary+JSON.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/14.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation

extension Dictionary {

    var prettyPrintedJsonString: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return String(bytes: jsonData, encoding: .utf8) ?? "JSON Covert Failre."
        } catch {
            return "JSON Covert Failre."
        }
    }
}
