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

    // MARK: - IBOutlet
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var convertedTextView: UITextView!
    @IBOutlet private weak var convertButton: UIButton!

    // MARK: - PanModal Property
    var panScrollable: UIScrollView?
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

    // MARK: - Private Property
    private let convertAPI = ConvertAPI()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hasLoaded = true
        inputTextView.delegate = self
        convertedTextView.isEditable = false
        convertAPI.returnCodeResult = self
    }

    // MARK: - IBAction
    @IBAction func didTapConvertButton(_ sender: UIButton) {
        inputTextView.endEditing(true)
        convertAPI.convert(inputTextView.text)
    }
}

// MARK: - PanModal Method
extension InputFromTextViewController {
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        switch state {
        case .longForm:
            inputTextView.becomeFirstResponder()
        case .shortForm:
            inputTextView.endEditing(true)
        }
    }
}

// MARK: - UITextViewDelegate
extension InputFromTextViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        hasLoaded = false
        panModalTransition(to: .longForm)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        hasLoaded = true
    }
}

// MARK: - ReturnCodeResult
extension InputFromTextViewController: ReturnCodeResult {
    func returnCodeResult(returnCode: IndividualResult) {
        switch returnCode {
        case .loading:
            break
        case .success(let result):
            guard let convertedData = result as? ConvertResponse else {
                return
            }
            convertedTextView.text = convertedData.converted
        case .decodeError:
            break
        case .failure(let error):
            break
        }
    }
}

// MARK: - class Method
extension InputFromTextViewController {
    static func instance() -> InputFromTextViewController {
        guard let viewController: InputFromTextViewController =
            UIStoryboard.viewController(
                storyboardName: InputFromTextViewController.className,
                identifier: InputFromTextViewController.className) else {
                    fatalError("InputFromTextViewController not found.")
        }
        return viewController
    }
}
