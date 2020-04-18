//
//  HistoryTableViewCell.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var convertedTextLabel: UILabel!
    @IBOutlet private weak var inputTextLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(_ convertEntity: ConvertEntity) -> HistoryTableViewCell {
        favoriteButton.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        convertedTextLabel.text = convertEntity.converted
        inputTextLabel.text = convertEntity.input
        favoriteButton.isSelected = convertEntity.favoriteFlg
        return self
    }
}
