//
//  UIViewController+ActivityIndicator.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/19.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

extension UIViewController {

    var activityIndicatorTag: Int {
        return Constants.ViewTags.activityIndicatorTag
    }

    func startActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            if let activityIndicator = weakSelf.activityIndicatorView {
                activityIndicator.startAnimating()
            } else {
                let activityIndicator = UIActivityIndicatorView()
                activityIndicator.tag = weakSelf.activityIndicatorTag
                activityIndicator.style = .large
                activityIndicator.layer.masksToBounds = true
                activityIndicator.layer.cornerRadius = 5.0;
                activityIndicator.layer.opacity = 0.8;
                activityIndicator.startAnimating()
                weakSelf.view.addSubview(activityIndicator)
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                activityIndicator.centerXAnchor.constraint(equalTo: weakSelf.view.centerXAnchor).isActive = true
                activityIndicator.centerYAnchor.constraint(equalTo: weakSelf.view.centerYAnchor).isActive = true
                activityIndicator.widthAnchor.constraint(equalTo: weakSelf.view.widthAnchor).isActive = true
                activityIndicator.heightAnchor.constraint(equalTo: weakSelf.view.heightAnchor).isActive = true
            }
        }
    }

    func stopActivityIndicator() {

        view.isUserInteractionEnabled = true

        DispatchQueue.main.async { [weak self] in
            guard self != nil else {
                return
            }
            self?.activityIndicatorView?.stopAnimating()
            self?.activityIndicatorView?.removeFromSuperview()
        }
    }
}

private extension UIViewController {

    var activityIndicatorView: UIActivityIndicatorView? {
        if let activityIndicator = view.subviews.filter(
            { $0.tag == activityIndicatorTag}).first as? UIActivityIndicatorView {
            return activityIndicator
        }
        return nil
    }
}
