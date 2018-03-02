//
//  URL+Icon.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 26.02.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit

extension URL {
    
    var favIconURL: URL? {
        guard let scheme = self.scheme, let host = self.host else {
            return nil
        }
        
        return URL(string: scheme + "://" + host + "/favicon.ico")
    }
    
    var appleTouchIconURL: URL? {
        guard let scheme = self.scheme, let host = self.host else {
            return nil
        }
        
        return URL(string: scheme + "://" + host + "/apple-touch-icon.png")
    }
}
