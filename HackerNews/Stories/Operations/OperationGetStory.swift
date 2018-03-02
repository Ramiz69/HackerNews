//
//  OperationGetStory.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 01.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import HackerNewsKit

final class OperationGetStory: Operation {
    
    public var story: Story?
    private var storyID: Int
    
    public init(_ storyID: Int) {
        self.storyID = storyID
        super.init()
        if isCancelled {
            return
        } else {
            main()
        }
    }
    
    override func main() {
        if isCancelled {
            return
        } else {
            StoriesManager.getStory(storyID, completionHandler: { (response, error) in
                guard let json = response as? JSON, error == nil else {
                    return
                }
                self.story = Story(json)
                if !UserDefaults.isIndexed {
                    if let story = self.story {
                       SpotlightManager.setDataForDisplay(with: story.title,
                                                          contentDescription: story.author,
                                                          creationDate: Date.correctDate(Date(timeIntervalSince1970: story.date)),
                                                          url: URL(string: story.url),
                                                          keyID: "\(self.storyID)",
                        completionHandler: { (error) in
                            
                       })
                    }
                }
                guard let completionBlock = self.completionBlock else {
                    return
                }
                completionBlock()
            })
        }
    }
}
