//
//  StoryViewController+UIViewControllerRestoration.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 07.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit

extension StoryViewController: UIViewControllerRestoration {
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
