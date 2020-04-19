//
//  ConvertRequest.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation

enum ConvertType: String {
    case hiragana
    case katakana
}

final class ConvertRequest: WebAPIRequestProtocol {
    var bodys: [String : Any]

    init(_ sentence: String, type: ConvertType) {

        let path = Bundle.main.path(forResource: "UniqueData", ofType: "plist") ?? ""
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let dic: Dictionary = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as! Dictionary<String, String>
        let appId = dic["app_id"]
        
        log?.info(appId)
        bodys = ["app_id": appId ?? "",
                 "sentence": sentence,
                 "output_type": type.rawValue]
    }
}
