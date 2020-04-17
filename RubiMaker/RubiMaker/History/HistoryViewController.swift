//
//  HistoryViewController.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit
import PanModal

final class HistoryViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var historyTableView: UITableView!

    // MARK: - Private Property
    private var inputFromTextViewController = InputFromTextViewController.instance()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presentPanModal(inputFromTextViewController)
    }
}
