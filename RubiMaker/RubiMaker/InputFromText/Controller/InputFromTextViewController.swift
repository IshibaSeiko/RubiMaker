//
//  InputFromTextViewController.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit
import GrowingTextView

protocol InputFromTextViewControllerDelegate: AnyObject {
    func textViewDidBeginEditing()
    func finishConvert()
}

enum ButtonStyle {
    case convert
    case reset
    case enable
}

final class InputFromTextViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var inputTextView: GrowingTextView!
    @IBOutlet weak var convertedTextView: GrowingTextView!
    @IBOutlet weak var convertButtonBackView: UIView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var convertTypeButton: UIButton!
    @IBOutlet weak var hiraganaLabel: UILabel!
    @IBOutlet weak var katakanaLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!

    // MARK: - InputFromTextViewControllerDelegate
    weak var delegate: InputFromTextViewControllerDelegate?

    // MARK: - Private Property
    private var convertAPI: ConvertAPIModel!
    var buttonStyle: ButtonStyle = .enable {
        didSet {
            switch buttonStyle {
            case .convert:
                convertButton.isSelected = false
                convertButton.isEnabled = true
                convertButton.alpha = 1.0

            case .reset:
                convertButton.isSelected = true
                convertButton.isEnabled = true
                convertButton.alpha = 1.0

            case .enable:
                convertButton.isEnabled = false
                convertButton.alpha = 0.3
            }
        }
    }
    var convertType: ConvertType = .hiragana {
        didSet {
            switch convertType {
            case .hiragana:
                convertButton.setTitle("ひらがなに変換", for: .normal)
                hiraganaLabel.textColor = .darkText
                katakanaLabel.textColor = .secondaryLabel

            case .katakana:
                convertButton.setTitle("カタカナに変換", for: .normal)
                hiraganaLabel.textColor = .secondaryLabel
                katakanaLabel.textColor = .darkText
            }
        }
    }

    private let textViewMinHeight: CGFloat = 50.0
    private let textViewMaxHeight: CGFloat = 150.0
    private let textViewMaxLength = 400

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.delegate = self
        convertedTextView.isEditable = false
        convertAPI.returnCodeResult = self
        buttonStyle = .enable
        setInterface()
    }

    // MARK: - IBAction
    @IBAction func didTapConvertButton(_ sender: UIButton) {
        switch buttonStyle {
        case .convert:
            inputTextView.resignFirstResponder()
            convertAPI.convert(inputTextView.text, type: convertType)

        case .reset:
            inputTextView.text = ""
            convertedTextView.text = ""
            copyButton.isEnabled = false
            inputTextView.becomeFirstResponder()
            buttonStyle = .enable

        case .enable:
            break
        }
    }

    @IBAction func didTapConvertTypeButton(_ sender: UIButton) {
        convertType = convertType == .hiragana ? .katakana : .hiragana
        buttonStyle = .convert
    }

    @IBAction func didTapCopyButton(_ sender: UIButton) {
        UIPasteboard.general.string = convertedTextView.text
        let alert = UIAlertController.init(title: nil, message: "クリップボードにコピーしました。", preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true)
            }
        }
    }
}

// MARK: - Instance Method
extension InputFromTextViewController {
    func isFull(_ isFull: Bool) {
        convertButtonBackView.isHidden = !isFull
        convertedTextView.isHidden = !isFull
        inputTextView.maxHeight = isFull ? textViewMaxHeight : textViewMinHeight
        inputTextView.minHeight = isFull ? textViewMaxHeight : textViewMinHeight
    }
}

// MARK: - Private Method
extension InputFromTextViewController {
    private func setInterface() {
        view.alpha = 0.8
        
        inputTextView.layer.borderWidth = 0.5
        inputTextView.layer.borderColor = UIColor.systemGray2.cgColor
        inputTextView.layer.cornerRadius = 5.0
        inputTextView.placeholder = "変換したいテキストを入力してください。"
        inputTextView.placeholderColor = .systemGray2
        inputTextView.minHeight = textViewMinHeight
        inputTextView.maxHeight = textViewMaxHeight
        inputTextView.maxLength = textViewMaxLength

        convertedTextView.layer.borderWidth = 0.5
        convertedTextView.layer.borderColor = UIColor.systemGray2.cgColor
        convertedTextView.layer.cornerRadius = 5.0
        convertedTextView.placeholder = "変換されたテキストが表示されます。"
        convertedTextView.placeholderColor = .systemGray2
        convertedTextView.minHeight = textViewMaxHeight
        convertedTextView.maxHeight = textViewMaxHeight

        convertButton.layer.borderWidth = 0.5
        convertButton.layer.borderColor = UIColor.systemGray2.cgColor
        convertButton.layer.cornerRadius = 15.0

        copyButton.isEnabled = false

        convertButton.setTitle("ひらがなに変換", for: .normal)
        convertButton.setTitle("リセット", for: .selected)

        isFull(false)
    }
}

// MARK: - UITextViewDelegate
extension InputFromTextViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView != inputTextView {
            return true
        }

        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        if text.contains("\n") {
            inputTextView.text = inputTextView.text
                + text.replacingOccurrences(of: "\n", with: " ")
            textViewDidChange(inputTextView)
            return false
        }

        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView != inputTextView {
            return
        }

        switch buttonStyle {
        case .convert:
            break

        case .reset, .enable:
            buttonStyle = .convert
        }

        if inputTextView.text.isEmpty {
            buttonStyle = .enable
        }
    }
}

// MARK: - ReturnCodeResult
extension InputFromTextViewController: ReturnCodeResult {
    func returnCodeResult(returnCode: IndividualResult) {
        switch returnCode {
        case .loading:
            startActivityIndicator()

        case .success(let result):
            guard let convertedData = result as? ConvertResponse else {
                return
            }
            convertedTextView.text = convertedData.converted
            copyButton.isEnabled = true
            HistoryDao.update(object: ConvertEntity(input: inputTextView.text,
                                                    convertResponse: convertedData))
            buttonStyle = .reset
            delegate?.finishConvert()
            stopActivityIndicator()

        case .failure(let error):
            log?.info(error)
            stopActivityIndicator()
            let alert = AlertHelper.buildAlert(message: returnCode.errorMessage)
            present(alert, animated: true)
            
        case .systemError, .payloadTooLarge, .rateLimitExceeded:
            stopActivityIndicator()
            let alert = AlertHelper.buildAlert(message: returnCode.errorMessage)
            present(alert, animated: true)
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
