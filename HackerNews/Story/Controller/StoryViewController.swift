//
//  StoryViewController.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 26.02.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import WebKit

final class StoryViewController: UIViewController {

    @IBOutlet weak private var webView: WKWebView!

    open var model: Story?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureController()
    }
    
    //MARK: - Custom methods
    
    private func configureController() {
        guard let model = model else {
            return
        }
        title = model.title
        if let url = URL(string: model.url) {
            webView.navigationDelegate = self
            webView.load(URLRequest(url: url))
            view.showActivityIndicator()
        }
    }
}

//MARK: - WKNavigationDelegate
extension StoryViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.removeActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.removeActivityIndicator()
    }
}
