//
//  ConvertResponse.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation

struct ConvertResponse: Decodable {
    let requestId: String
    let outputType: String
    let converted: String
}

struct ConvertErrorResponse: Decodable {
    let error: ConvertError
}

struct ConvertError: Decodable {
    let code: Int
    let message: String
}

enum ConvertAPIError: String {
    case contentTypeIsEmpty = "Content-Type is Empty"
    case invalidJSON = "Invalid JSON"
    case invalidContentType = "Invalid Content-Type"
    case invalidRequestParamete = "Invalid request parameter"
    case suspendedAppId = "Suspended app_id"
    case invalidAppId = "Invalid app_id"
    case rateLimitExceeded = "Rate limit exceeded"
}
