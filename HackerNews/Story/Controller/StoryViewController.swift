//
//  StoryViewController.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 26.02.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import WebKit

final class StoryViewController: UIViewController, WKNavigationDelegate, UIViewControllerRestoration {

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
    
    //MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.removeActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.removeActivityIndicator()
    }
    
    //MARK: - UIViewControllerRestoration
    
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        let viewController = StoryViewController()
        return viewController
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let model = model else { return }
        do {
            let modelData = try JSONEncoder().encode(model)
            coder.encode(modelData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        guard let data = coder.decodeData() else { return }
        do {
            model = try JSONDecoder().decode(Story.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
