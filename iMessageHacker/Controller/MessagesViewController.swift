//
//  MessagesViewController.swift
//  iMessageHacker
//
//  Created by Рамиз Кичибеков on 03.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import Messages
import HackerNewsKit
import SafariServices

class MessagesViewController: MSMessagesAppViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
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
    
    private func composeMessage(_ story: Story) {
        guard let conversation = activeConversation, let url = URL(string: story.url) else {
            return
        }
        let layout = MSMessageTemplateLayout()
        layout.caption = story.title
        layout.subcaption = story.author
        layout.trailingSubcaption = String.correctFormatDate(Date(timeIntervalSince1970: story.date))
        
        let message = MSMessage(session: conversation.selectedMessage?.session ?? MSSession())
        message.url = url
        message.layout = layout
        
        conversation.insert(message, completionHandler: nil)
    }
    
    private func openSafariViewController(with conversation: MSConversation) {
        guard let url = conversation.selectedMessage?.url else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @IBAction private func didTapSegmentControl(_ sender: UISegmentedControl) {
        guard let selectedContentType = ContentType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        contentType = selectedContentType
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        openSafariViewController(with: conversation)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        guard presentationStyle == .expanded, let conversation = activeConversation else {
                return
        }
        openSafariViewController(with: conversation)
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
        composeMessage(story)
    }
    
    //MARK: - SFSafariViewControllerDelegate
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
