//
//  UserDefaults.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 02.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import Foundation

extension UserDefaults {
    private static let indexingKey = "IndexingKey"
    
    class func didSaveIndexingValue(_ isIndexed: Bool) {
        self.standard.set(!isIndexed, forKey: indexingKey)
        self.standard.synchronize()
    }
    
    public class var isIndexed: Bool {
        return self.standard.bool(forKey: indexingKey)
    }
}
