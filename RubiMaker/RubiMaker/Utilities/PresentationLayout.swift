//
//  PresentationLayout.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

public enum DrawerPositionType: Int {
    case full   //最大限表示
    case half   //半分
    case tip    //上部のみ

    func isBeginningArea(fractionPoint: CGFloat, velocity: CGPoint, halfAreaBorderPoint: CGFloat) -> Bool {
        switch self {
        case .tip:
            return velocity.y > 300 || ..<0.2 ~= fractionPoint && velocity.y >= 0.0 || halfAreaBorderPoint >= fractionPoint && velocity.y > 0
        case .full:
            return velocity.y < 0.0 || ..<0.35 ~= fractionPoint && velocity.y <= 0.0 || halfAreaBorderPoint >= fractionPoint && velocity.y < 0.0
        case .half:
            fatalError()
        }
    }

    func isEndArea(fractionPoint: CGFloat, velocity: CGPoint, halfAreaBorderPoint: CGFloat) -> Bool {
        switch self {
        case .tip:
            return velocity.y < -300 || 0.65... ~= fractionPoint && velocity.y <= 0 || halfAreaBorderPoint <= fractionPoint && velocity.y < 0
        case .full:
            return velocity.y > 300 || 0.8... ~= fractionPoint && velocity.y >= 0 || halfAreaBorderPoint <= fractionPoint && velocity.y > 0
        case .half:
            fatalError()
        }
    }
}
