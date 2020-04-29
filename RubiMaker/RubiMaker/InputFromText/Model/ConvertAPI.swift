//
//  ConvertAPI.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation

protocol ConvertAPIModel: AnyObject {
    func convert(_ sentence: String, type: ConvertType, delegate: ReturnCodeResult?)
}

final class ConvertAPI: ConvertAPIModel {
    func convert(_ sentence: String, type: ConvertType, delegate: ReturnCodeResult?) {
        let request = ConvertRequest(sentence, type: type)
        delegate?.returnCodeResult(returnCode: .loading)
        
        APIClient.request(request: request) { response in
            switch response {
            case .success(let result):
                guard let result = result else {
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let decodedResult = try? decoder.decode(ConvertResponse.self, from: result) {
                    delegate?.returnCodeResult(returnCode: .success(decodedResult))
                    return
                }
                
                if let decodedResult = try? decoder.decode(ConvertErrorResponse.self, from: result) {
                    let errorType = ConvertAPIError(rawValue: decodedResult.error.message)
                    switch errorType {
                    case .rateLimitExceeded:
                        delegate?.returnCodeResult(returnCode: .rateLimitExceeded)
                    default:
                        break
                    }
                }
                delegate?.returnCodeResult(returnCode: .systemError)
                
            case .failure(let error):
                
                switch error {
                case ErrorResult.payloadTooLarge:
                    delegate?.returnCodeResult(returnCode: .payloadTooLarge)
                    
                case ErrorResult.notFound,
                     ErrorResult.badRequest,
                     ErrorResult.methodNotAllowed,
                     ErrorResult.internalServerError:
                    delegate?.returnCodeResult(returnCode: .systemError)
                    
                default:
                    delegate?.returnCodeResult(returnCode: .failure(error))
                }
            }
        }
    }
}
