//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Рамиз Кичибеков on 03.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import NotificationCenter
import HackerNewsKit

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak private var tableView: UITableView!
    private var operationsInProgress = [IndexPath: OperationGetStory]()
    private var stories: [Any]?
    private var contentType: ContentType = .newStories {
        didSet {
            updateDataManual()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    deinit {
        operationsInProgress.removeAll()
        stories?.removeAll()
    }
    
    //MARK: - Custom methods
    
    private func configureController() {
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        tableView.register(UINib(nibName: String(describing: StoryTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: StoryTableViewCell.self))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateDataManual()
        }
    }
    
    private func reloadTable(_ storiesID: [Int]?) {
        stories = storiesID
        tableView.reloadData()
    }
    
    private func updateDataManual() {
        updateData() {
            
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
    
    @IBAction private func didTapSegmentControl(_ sender: UISegmentedControl) {
        guard let selectedContentType = ContentType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        contentType = selectedContentType
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadIfNeddedStory(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoryTableViewCell.self), for: indexPath) as! StoryTableViewCell
        if let model = stories?[indexPath.row] as? Story {
            cell.configureCell(with: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        operationsInProgress[indexPath]?.cancel()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let story = stories?[indexPath.row] as? Story else {
            return
        }
        extensionContext?.open(URL(string: story.url)!, completionHandler: nil)
    }
    
    //MARK: - NCWidgetProviding
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.newData)
    }

}
