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
    case contentTypeIsEmpty
    case invalidJSON
    case invalidContentType
    case invalidRequestParamete
    case suspendedAppId
    case invalidAppId
    case rateLimitExceeded
    case notFound
    case methodNotAllowed
    case requestToLarge
    case internalServerError

    var message: String {
        switch self {
        case .contentTypeIsEmpty:
            return "Content-Type is empty"
        case .invalidJSON:
            return "Invalid JSON"
        case .invalidContentType:
            return "Invalid Content-Type"
        case .invalidRequestParamete:
            return "Invalid request parameter"
        case .suspendedAppId:
            return "Suspended app_id"
        case .invalidAppId:
            return "Invalid app_id"
        case .rateLimitExceeded:
            return "Rate limit exceeded"
        case .notFound:
            return "Not found:"
        case .methodNotAllowed:
            return "Method not allowed."
        case .requestToLarge:
            return "Request to large"
        case .internalServerError:
            return "Internal Server Error"
        }
    }
}
