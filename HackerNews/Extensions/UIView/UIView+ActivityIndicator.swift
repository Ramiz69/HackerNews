//
//  UIView+ActivityIndicator.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 26.02.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit

extension UIView {

    func showActivityIndicator() {
        executeOnMainThread {
            self.removeActivityIndicator()
            
            self.isUserInteractionEnabled = false
            let activityIndicatorView = UIActivityIndicatorView(frame: self.bounds)
            activityIndicatorView.style = .gray
            activityIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
        }
    }
    
    func removeActivityIndicator() {
        executeOnMainThread {
            while let activityIndicator = self.subviews.first(where: { $0 is UIActivityIndicatorView }) {
                activityIndicator.removeFromSuperview()
            }
            self.isUserInteractionEnabled = true
        }
    }
}
