//
//  ReturnCodeResult.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

enum IndividualResult {
    case loading
    case success(T: Decodable)
    case failure(_ error: Error)
}

protocol ReturnCodeResult: class {
    func returnCodeResult(returnCode: IndividualResult)
}

