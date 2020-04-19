//
//  ConvertResponseStub.swift
//  RubiMakerTests
//
//  Created by 石場清子 on 2020/04/19.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation
@testable import RubiMaker

final class ConvertResponseStub: ConvertAPIModel {
    var returnCodeResult: ReturnCodeResult?

    private var requestId: String
    private var outputType: String
    private var converted: String

    func convert(_ sentence: String, type: ConvertType) {
        returnCodeResult?.returnCodeResult(returnCode: .success(ConvertResponse(requestId: requestId,
                                                                                outputType: outputType,
                                                                                converted: converted)))
    }

    init(requestId: String, outputType: String, converted: String) {
        self.requestId = requestId
        self.outputType = outputType
        self.converted = converted
    }
}
