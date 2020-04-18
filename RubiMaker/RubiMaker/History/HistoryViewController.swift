//
//  HistoryViewController.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit
import FloatingPanel

final class HistoryViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var historyTableView: UITableView!

    // MARK: - Private Property
    private var inputFromTextViewController = InputFromTextViewController.instance()
    let floatingPanelController = FloatingPanelController()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inputFromTextViewController.delegate = self
        floatingPanelController.delegate = self
        floatingPanelController.set(contentViewController: inputFromTextViewController)
        floatingPanelController.addPanel(toParent: self, animated: true)
    }
}

extension HistoryViewController: InputFromTextViewControllerDelegate {
    func textViewDidBeginEditing() {
        floatingPanelController.move(to: .full, animated: true)
    }
}

// MARK: - FloatingPanelControllerDelegate
extension HistoryViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return FloatingPanelLandscapeLayout()
    }

    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        switch targetPosition {
        case .full:
            break

        case .tip:
            inputFromTextViewController.inputTextView.endEditing(true)

        case .half, .hidden:
        break
        }
    }
}
