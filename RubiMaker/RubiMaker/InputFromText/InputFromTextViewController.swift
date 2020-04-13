//
//  InputFromTextViewController.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

final class InputFromTextViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var convertedTextView: UITextView!
    @IBOutlet private weak var convertButton: UIButton!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
