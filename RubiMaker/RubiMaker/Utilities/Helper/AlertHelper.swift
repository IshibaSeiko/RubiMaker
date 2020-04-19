//
//  AlertHelper.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/19.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

final class AlertHelper {
    typealias AlertActionType = ((UIAlertAction) -> Void)

    static func buildAlert(title: String? = nil,
                           message: String,
                           rightButtonTitle: String = "OK",
                           leftButtonTitle: String? = nil,
                           rightButtonAction: AlertActionType? = nil,
                           leftButtonAction: AlertActionType? = nil) -> UIAlertController {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        let positiveAction = UIAlertAction(title: rightButtonTitle,
                                           style: .default,
                                           handler: rightButtonAction)
        alert.addAction(positiveAction)

        if let leftButtonTitle = leftButtonTitle {
            let negativeAction = UIAlertAction(title: leftButtonTitle,
                                               style: .cancel,
                                               handler: leftButtonAction)
            alert.addAction(negativeAction)
        }
        return alert
    }
}
