//
//  StoriesViewController.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 07.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import HackerNewsKit

protocol StoriesViewControllerDelegate {
    func changeAppIcon(_ iconName: IconType)
}

class StoriesViewController: UIViewController {
    
    @IBOutlet weak public var tableView: UITableView!
    @IBOutlet weak public var segmentControl: UISegmentedControl!
    
    public var delegate: StoriesViewControllerDelegate?
    
    public var operationsInProgress = [IndexPath: OperationGetStory]()
    public var stories: [Any]?
    
    public var contentType: ContentType = .newStories {
        didSet {
            if segmentControl.selectedSegmentIndex != contentType.rawValue {
                segmentControl.selectedSegmentIndex = contentType.rawValue
                changeAppIcon()
                updateDataManual()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateDataManual()
        }
    }
    
    deinit {
        operationsInProgress.removeAll()
        stories?.removeAll()
    }
    
    //MARK: - Custom methods
    //MARK: - Public methods
    
    public func reloadTable(_ storiesID: [Int]?) {
        stories = storiesID
        tableView.reloadData()
    }
    
    public func loadIfNeddedStory(at indexPath: IndexPath) {
        if let storyID = stories?[indexPath.row] as? Int {
            let operation = OperationGetStory(storyID)
            operation.completionBlock = {
                if indexPath.row < self.stories?.count ?? 0 {
                    self.stories?[indexPath.row] = operation.story ?? NSNotFound
                    self.reloadRow(at: indexPath)
                }
            }
            operationsInProgress[indexPath] = operation
        }
    }
    
    //MARK: - Private methods
    
    private func configureController() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: StoryTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: StoryTableViewCell.self))
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self as! UIViewControllerPreviewingDelegate, sourceView: tableView)
        }
    }
    
    private func changeAppIcon() {
        if let rawIconName = IconType(rawValue: segmentControl.selectedSegmentIndex) {
            delegate?.changeAppIcon(rawIconName)
        }
    }
    
    private func updateDataManual() {
        title = contentType.description
        updateData() {
            
        }
    }
    
    private func updateData(_ completion: @escaping () -> ()) {
        executeOnMainThread { [weak self] in
            self?.operationsInProgress.removeAll()
        }
        let operation = OperationGetStories(contentType)
        operation.completionBlock = {
            self.executeOnMainThread { [weak self] in
                self?.reloadTable(operation.storiesID)
                completion()
            }
        }
    }
    
    private func reloadRow(at indexPath: IndexPath) {
        executeOnMainThread { [weak self] in
            if let cell = self?.tableView.cellForRow(at: indexPath) as? StoryTableViewCell,
                let story = self?.stories?[indexPath.row] as? Story {
                cell.configureCell(with: story)
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func didTapSegmentControl(_ sender: UISegmentedControl) {
        guard let selectedContentType = ContentType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        changeAppIcon()
        contentType = selectedContentType
        updateDataManual()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StoryViewController {
            destination.model = sender as? Story
        }
    }
    
}
