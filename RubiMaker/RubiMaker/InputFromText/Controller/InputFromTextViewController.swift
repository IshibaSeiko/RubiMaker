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
    func finishConvert()
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
    private var convertAPI: ConvertAPIModel!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.delegate = self
        convertedTextView.isEditable = false
        convertAPI.returnCodeResult = self
        convertButton.isEnabled = false
        convertButton.alpha = 0.5
        setInterface()
    }

    // MARK: - IBAction
    @IBAction func didTapConvertButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.isSelected {
        case true:
            inputTextView.endEditing(true)
            convertAPI.convert(inputTextView.text, type: .hiragana)
        case false:
            inputTextView.text = ""
            convertedTextView.text = ""
            convertButton.isEnabled = false
            convertButton.alpha = 0.5
            inputTextView.becomeFirstResponder()
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

// MARK: - Private Method
extension InputFromTextViewController {
    private func setInterface() {
        inputTextView.layer.borderWidth = 0.5
        inputTextView.layer.borderColor = UIColor.gray.cgColor
        inputTextView.layer.cornerRadius = 5.0

        convertedTextView.layer.borderWidth = 0.5
        convertedTextView.layer.borderColor = UIColor.gray.cgColor
        convertedTextView.layer.cornerRadius = 5.0

        convertButton.layer.borderWidth = 0.5
        convertButton.layer.borderColor = UIColor.gray.cgColor
        convertButton.layer.cornerRadius = 15.0

        convertButton.setTitle("Convert", for: .normal)
        convertButton.setTitle("Reset", for: .selected)

        bottomView.topAnchor.constraint(equalTo: inputTextView.topAnchor, constant: 50).isActive = true
        isFull(false)
    }
}

// MARK: - UITextViewDelegate
extension InputFromTextViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
    }

    func textViewDidChange(_ textView: UITextView) {
        if convertButton.isSelected {
            convertButton.isSelected = false
            convertedTextView.text = ""
        }
        convertButton.isEnabled = !inputTextView.text.isEmpty
        convertButton.alpha = convertButton.isEnabled ? 1 : 0.5
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
            HistoryDao.update(object: ConvertEntity(input: inputTextView.text,
                                                    convertResponse: convertedData))
            delegate?.finishConvert()
        case .decodeError:
            break
        case .failure(let error):
            break
        }
    }
}

// MARK: - class Method
extension InputFromTextViewController {
    static func instance(convertAPI: ConvertAPIModel) -> InputFromTextViewController {
        guard let viewController: InputFromTextViewController =
            UIStoryboard.viewController(
                storyboardName: InputFromTextViewController.className,
                identifier: InputFromTextViewController.className) else {
                    fatalError("InputFromTextViewController not found.")
        }
        viewController.convertAPI = convertAPI
        return viewController
    }
}
