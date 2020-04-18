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
        bodys = ["app_id":"efd3b572c82d110f1b0e9e6fea1df08a606e956933998bab17f3f723dfda682e",
                 "sentence": sentence,
                 "output_type": type.rawValue]
    }

}
