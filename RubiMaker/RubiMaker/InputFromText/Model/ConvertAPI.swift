//
//  ConvertAPI.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation

protocol ConvertAPIModel: AnyObject {
    var returnCodeResult: ReturnCodeResult? { get set }
    func convert(_ sentence: String, type: ConvertType)
}

final class ConvertAPI: ConvertAPIModel {
    weak var returnCodeResult: ReturnCodeResult?

    func convert(_ sentence: String, type: ConvertType) {
        let request = ConvertRequest(sentence, type: type)
        returnCodeResult?.returnCodeResult(returnCode: .loading)

        APIClient.request(request: request) { response in
            switch response {
            case .success(let result):
                guard let result = result else {
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                if let decodedResult = try? decoder.decode(ConvertResponse.self, from: result) {
                    self.returnCodeResult?.returnCodeResult(returnCode: .success(decodedResult))
                }

                if let decodedResult = try? decoder.decode(ConvertErrorResponse.self, from: result) {
                    let errorType = ConvertAPIError(rawValue: decodedResult.error.message)
                    switch errorType {
                    case .rateLimitExceeded:
                        self.returnCodeResult?.returnCodeResult(returnCode: .rateLimitExceeded)
                    default:
                        self.returnCodeResult?.returnCodeResult(returnCode: .systemError)
                    }
                }
                self.returnCodeResult?.returnCodeResult(returnCode: .systemError)

            case .failure(let error):

                switch error {
                case ErrorResult.payloadTooLarge:
                    self.returnCodeResult?.returnCodeResult(returnCode: .payloadTooLarge)
                case ErrorResult.notFound,
                     ErrorResult.badRequest,
                     ErrorResult.methodNotAllowed,
                     ErrorResult.internalServerError:
                    self.returnCodeResult?.returnCodeResult(returnCode: .systemError)
                default:
                    break
                }

                self.returnCodeResult?.returnCodeResult(returnCode: .failure(error))
                break
            }
        }
    }
}
