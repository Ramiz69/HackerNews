//
//  ServerError.swift
//  HackerNewsKit
//
//  Created by Рамиз Кичибеков on 02.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import Foundation

public struct ServerError {
    
    let сode: Int
    let description: String
    let debugMessage: String?
    let details: [String: String]?
    
    public init?(rawResponse: Any?) {
        
        guard
            let serverErrorDic = rawResponse as? [String: Any],
            let description = serverErrorDic["description"] as? String,
            let сode = serverErrorDic["error_code"] as? Int
            else {
                return nil
        }
        
        self.description = description
        self.сode = сode
        self.debugMessage = serverErrorDic["debug_message"] as? String
        self.details = serverErrorDic["details"] as? [String: String]
    }
}
