//
//  MainNavigationController.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 07.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    //MARK: - Custom methods
    
    private func configureController() {
        guard let storiesViewController = viewControllers.first as? StoriesViewController else { return }
        storiesViewController.delegate = self
    }
    
}

extension MainNavigationController: StoriesViewControllerDelegate {
    func changeAppIcon(_ iconName: IconType) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIApplication.shared.setAlternateIconName(iconName.description == "New" ? nil : iconName.description) { error in
                guard error != nil else { return }
            }
        }
    }
}
