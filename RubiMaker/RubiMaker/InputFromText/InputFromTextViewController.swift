//
//  InputFromTextViewController.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

protocol InputFromTextViewControllerDelegate: AnyObject {
    func textViewDidBeginEditing()
}

final class InputFromTextViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet private weak var convertedTextView: UITextView!
    @IBOutlet weak var convertButtonBackView: UIView!
    @IBOutlet private weak var convertButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!

    // MARK: - InputFromTextViewControllerDelegate
    weak var delegate: InputFromTextViewControllerDelegate?

    // MARK: - Private Property
    private let convertAPI = ConvertAPI()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.delegate = self

        inputTextView.layer.borderWidth = 0.5
        inputTextView.layer.borderColor = UIColor.gray.cgColor
        inputTextView.layer.cornerRadius = 5.0

        convertedTextView.layer.borderWidth = 0.5
        convertedTextView.layer.borderColor = UIColor.gray.cgColor
        convertedTextView.layer.cornerRadius = 5.0

        convertButton.layer.borderWidth = 0.5
        convertButton.layer.borderColor = UIColor.gray.cgColor
        convertButton.layer.cornerRadius = 15.0

        convertedTextView.isEditable = false
        convertAPI.returnCodeResult = self
        convertButton.setTitle("Convert", for: .normal)
        convertButton.setTitle("Reset", for: .selected)
        bottomView.topAnchor.constraint(equalTo: inputTextView.topAnchor, constant: 50).isActive = true
        isFull(false)
    }

    // MARK: - IBAction
    @IBAction func didTapConvertButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.isSelected {
        case true:
            inputTextView.endEditing(true)
            convertAPI.convert(inputTextView.text)
        case false:
            inputTextView.text = ""
            convertedTextView.text = ""
        }

    }
}

// MARK: - Instance Method
extension InputFromTextViewController {
    func isFull(_ isFull: Bool) {
        convertButtonBackView.isHidden = !isFull
        convertedTextView.isHidden = !isFull
        bottomView.isHidden = isFull
    }
}

// MARK: - UITextViewDelegate
extension InputFromTextViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
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
