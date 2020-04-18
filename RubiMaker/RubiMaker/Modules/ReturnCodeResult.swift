//
//  ReturnCodeResult.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation

enum IndividualResult {
    case loading
    case success(_ T: Decodable)
    case failure(_ error: Error)
    case decodeError
}

protocol ReturnCodeResult: AnyObject {
    func returnCodeResult(returnCode: IndividualResult)
}

