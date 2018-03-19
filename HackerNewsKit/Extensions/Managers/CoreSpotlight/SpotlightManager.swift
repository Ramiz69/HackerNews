//
//  SpotlightManager.swift
//  HackerNewsKit
//
//  Created by Рамиз Кичибеков on 02.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

public class SpotlightManager {
    
    public class func setDataForDisplay(with title: String? = nil,
                                        contentDescription: String? = nil,
                                        keywords: [String]? = nil,
                                        creationDate: Date? = nil,
                                        url: URL? = nil,
                                        keyID: String,
                                        completionHandler: @escaping ErrorBlock) {
        let attributedSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributedSet.title = title
        attributedSet.contentDescription = contentDescription
        attributedSet.contentCreationDate = creationDate
        attributedSet.contentURL = url
        attributedSet.keywords = keywords
        searchableForIndexKey(keyID, attributedSet: attributedSet, completionHandler: completionHandler)
    }
    
    public class func deleteData(by indexKeys: [String], complectionHandler: @escaping ErrorBlock) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: indexKeys, completionHandler: complectionHandler)
    }
    
    public class func deleteAllData() {
        CSSearchableIndex.default().deleteAllSearchableItems { (error) in
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Private methods
    
    private class func searchableForIndexKey(_ indexKey: String,
                                             attributedSet: CSSearchableItemAttributeSet,
                                             completionHandler: @escaping ErrorBlock) {
        let item = CSSearchableItem(uniqueIdentifier: indexKey,
                                    domainIdentifier: Bundle.main.bundleIdentifier,
                                    attributeSet: attributedSet)
        CSSearchableIndex.default().indexSearchableItems([item], completionHandler: completionHandler)
    }
    
}
