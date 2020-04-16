//
//  InputFromTextViewController.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit
import PanModal

final class InputFromTextViewController: UIViewController, PanModalPresentable {
    var panScrollable: UIScrollView?

    // MARK: - IBOutlet
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var convertedTextView: UITextView!
    @IBOutlet private weak var convertButton: UIButton!

    var hasLoaded = false
    var shortFormHeight: PanModalHeight {
        if hasLoaded {
            return .contentHeight(200)
        }
        return .maxHeight
    }

    var allowsDragToDismiss: Bool {
        return false
    }

    var allowsTapToDismiss: Bool {
        return false
    }

    var panModalBackgroundColor: UIColor {
        return .clear
    }

    var isUserInteractionEnabled: Bool {
        return false
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hasLoaded = true
    }
}

extension InputFromTextViewController {
    class func instance() -> InputFromTextViewController {
        guard let viewController: InputFromTextViewController =
            UIStoryboard.viewController(
                storyboardName: InputFromTextViewController.className,
                identifier: InputFromTextViewController.className) else {
                    fatalError("InputFromTextViewController not found.")
        }
        return viewController
    }
}
