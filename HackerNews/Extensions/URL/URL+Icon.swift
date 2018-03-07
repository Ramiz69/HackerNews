//
//  URL+Icon.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 26.02.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit

extension URL {
    
    func getFaviconImageFromURL(_ isFavicon: Bool = false) -> URL? {
        guard let scheme = self.scheme, let host = self.host else { return nil }
        
        return URL(string: scheme + "://" + host + (isFavicon ? "/favicon.ico" : "/apple-touch-icon.png"))
    }
}
