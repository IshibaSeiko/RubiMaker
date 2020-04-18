//
//  CustomFloatingPanelLayout.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/18.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit
import FloatingPanel

class FloatingPanelLandscapeLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full , .tip]
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0
        case .tip: return 69.0
        default: return nil
        }
    }
}
