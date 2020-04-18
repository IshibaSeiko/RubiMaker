//
//  HIstoryListProvider.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/18.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

protocol HistoryListProviderProtocol: AnyObject {
    func historyStatus(_ newElement: ConvertEntity)
}

final class HistoryListProvider: NSObject {

    weak var delegate: HistoryListProviderProtocol?

    fileprivate var history = [ConvertEntity]()

    func set(_ history: [ConvertEntity]) {
        self.history = history
    }

    func history(index: Int) -> ConvertEntity {
        return history[index]
    }
}

extension HistoryListProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.isEmpty ? 1 : history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if history.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = "変換履歴はありません"
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.className, for: indexPath) as? HistoryTableViewCell else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "変換履歴はありません"
            return cell
        }
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(changeFavoriteStatus(_:)), for: .touchUpInside)
        return cell.setCell(history[indexPath.row])
    }
}

extension HistoryListProvider {
    @objc func changeFavoriteStatus(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        delegate?.historyStatus(ConvertEntity(convertEntity: history(index: sender.tag), changeFavoriteStatus: true))
    }
}
