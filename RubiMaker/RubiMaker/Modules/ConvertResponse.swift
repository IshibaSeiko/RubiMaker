//
//  ConvertResponse.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

struct ConvertResponse: Decodable {
    let requestId: String
    let outputType: String
    let converted: String
}
