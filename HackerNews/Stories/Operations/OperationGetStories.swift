//
//  OperationGetStories.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 02.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import HackerNewsKit

final class OperationGetStories: Operation {
    
    public var contentType: ContentType
    public var storiesID: [Int]?
    
    public init(_ contentType: ContentType) {
        self.contentType = contentType
        super.init()
        cancelOperation()
        main()
    }
    
    override func main() {
        cancelOperation()
        StoriesManager.getStories(contentType, completionHandler: { (response, error) in
            guard let items = response as? [Int], error == nil else {
                self.storiesID = nil
                return
            }
            self.storiesID = items
            self.cancelOperation()
            guard let completionBlock = self.completionBlock else {
                return
            }
            completionBlock()
        })
    }
}
