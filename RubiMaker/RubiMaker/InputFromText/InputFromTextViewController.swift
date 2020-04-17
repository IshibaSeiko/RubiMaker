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

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hasLoaded = true
        inputTextView.delegate = self
        convertedTextView.isEditable = false
    }

    func willTransition(to state: PanModalPresentationController.PresentationState) {
        switch state {
        case .longForm:
            inputTextView.becomeFirstResponder()
        case .shortForm:
            inputTextView.endEditing(true)
        }
    }
}

extension InputFromTextViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        hasLoaded = false
        panModalTransition(to: .longForm)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        hasLoaded = true
        panModalTransition(to: .shortForm)
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
