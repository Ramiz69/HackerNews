//
//  StoriesViewController.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 26.02.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import HackerNewsKit

final class StoriesViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    private var operationsInProgress = [IndexPath: OperationGetStory]()
    private var stories: [Any]?
    @IBOutlet weak private var segmentControl: UISegmentedControl!
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
    
    private func configureController() {
        tableView.register(UINib(nibName: String(describing: StoryTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: StoryTableViewCell.self))
        registerForPreviewing(with: self, sourceView: tableView)
    }
    
    private func changeAppIcon() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let rawIconName = IconType(rawValue: self.segmentControl.selectedSegmentIndex) else { return }
            let iconName = rawIconName.description == "New" ? nil : rawIconName.description
            UIApplication.shared.setAlternateIconName(iconName) { error in
                guard let error = error else {
                    return
                }
                print(error.localizedDescription)
            }
        }
    }
    
    private func reloadTable(_ storiesID: [Int]?) {
        stories = storiesID
        tableView.reloadData()
    }
    
    private func updateDataManual() {
        title = contentType.description
        refreshControl?.beginRefreshing()
        updateData() { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    private func updateData(_ completion: @escaping () -> ()) {
        self.executeOnMainThread { [weak self] in
            self?.operationsInProgress.removeAll()
        }
        let operation = OperationGetStories(contentType)
        operation.completionBlock = {
            self.executeOnMainThread {
                self.reloadTable(operation.storiesID)
                completion()
            }
        }
    }
    
    private func reloadRow(at indexPath: IndexPath) {
        executeOnMainThread {
            if let cell = self.tableView.cellForRow(at: indexPath) as? StoryTableViewCell,
                let story = self.stories?[indexPath.row] as? Story {
                cell.configureCell(with: story)
            }
        }
    }
    
    private func loadIfNeddedStory(at indexPath: IndexPath) {
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
    
    //MARK: - Actions
    
    @IBAction private func didChangeRefreshControl(_ sender: UIRefreshControl) {
        updateData() { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction private func didTapSegmentControl(_ sender: UISegmentedControl) {
        guard let selectedContentType = ContentType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        changeAppIcon()
        contentType = selectedContentType
        updateDataManual()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadIfNeddedStory(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoryTableViewCell.self), for: indexPath) as! StoryTableViewCell
        if let model = stories?[indexPath.row] as? Story {
            cell.configureCell(with: model)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        operationsInProgress[indexPath]?.cancel()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let story = stories?[indexPath.row] else {
            return
        }
        performSegue(withIdentifier: String(describing: StoryViewController.self), sender: story)
    }
    
    //MARK: - UIViewControllerPreviewingDelegate
    
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
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StoryViewController {
            destination.model = sender as? Story
        }
    }
    
    //MARK: - UIViewControllerRestoration
    
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        let viewController = StoriesViewController()
        return viewController
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard isViewLoaded else {
            return
        }
        coder.encode(segmentControl.selectedSegmentIndex, forKey: KeyType.segmentControlKey.rawValue)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        contentType = ContentType(rawValue:coder.decodeInteger(forKey: KeyType.segmentControlKey.rawValue)) ?? .newStories
    }
}
