//
//  StoriesViewController+UIViewControllerPreviewingDelegate.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 07.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit

extension StoriesViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location), let stories = stories?[indexPath.row], let story = stories as? Story else {
            return nil
        }
        let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: StoryViewController.self)) as! StoryViewController
        viewController.model = story
        
        return viewController
    }
}
