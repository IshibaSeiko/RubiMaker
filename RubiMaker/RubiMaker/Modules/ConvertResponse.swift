//
//  ConvertResponse.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

struct ConvertResponse: Decodable {
    let request_id: String
    let output_type: String
    let converted: String
}
