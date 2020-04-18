//
//  GetClassName.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

protocol GetClassName {
}

extension GetClassName {
    static var className: String {

        return String(describing: self)
    }
}

extension NSObject: GetClassName { }
