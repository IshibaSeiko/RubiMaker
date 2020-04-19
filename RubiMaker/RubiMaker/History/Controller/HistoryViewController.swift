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
    private var inputFromTextViewController = InputFromTextViewController.instance(convertAPI: ConvertAPI())
    private let floatingPanelController = FloatingPanelController()
    private let historyListProvider = HistoryListProvider()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTableView.register(UINib(nibName: HistoryTableViewCell.className, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.className)
        historyTableView.tableFooterView = UIView()
        historyTableView.delegate = self
        historyTableView.dataSource = historyListProvider
        historyListProvider.delegate = self
        historyListProvider.set(HistoryDao.findUnDeleteObjects())
        historyTableView.reloadData()

        inputFromTextViewController.delegate = self
        floatingPanelController.delegate = self
        floatingPanelController.surfaceView.cornerRadius = 10.0
        floatingPanelController.set(contentViewController: inputFromTextViewController)
        floatingPanelController.addPanel(toParent: self, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
            HistoryDao.update(object: ConvertEntity(convertEntity: self.historyListProvider.history(index: indexPath.row), changeDeleteStatus: true))
            self.historyListProvider.set(HistoryDao.findUnDeleteObjects())

            if HistoryDao.findUnDeleteObjects().isEmpty {
                self.historyTableView.reloadRows(at: [indexPath], with: .left)
            } else {
                self.historyTableView.deleteRows(at: [indexPath], with: .left)
            }
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return HistoryDao.findUnDeleteObjects().isEmpty ? .none : configuration
    }
}

// MARK: - HistoryListProviderProtocol
extension HistoryViewController: HistoryListProviderProtocol {
    func historyStatus(_ newElement: ConvertEntity) {
        HistoryDao.update(object: newElement)
        historyTableView.reloadData()
    }
}

// MARK: - InputFromTextViewControllerDelegate
extension HistoryViewController: InputFromTextViewControllerDelegate {
    func textViewDidBeginEditing() {
        floatingPanelController.move(to: .full, animated: true)
        inputFromTextViewController.isFull(true)
    }

    func finishConvert() {
        historyListProvider.set(HistoryDao.findUnDeleteObjects())
        historyTableView.reloadData()
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
            inputFromTextViewController.isFull(true)

        case .tip:
            inputFromTextViewController.inputTextView.endEditing(true)
            inputFromTextViewController.isFull(false)

        case .half, .hidden:
        break
        }
    }
}
