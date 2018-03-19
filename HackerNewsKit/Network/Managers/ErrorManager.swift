//
//  ErrorManager.swift
//  HackerNewsKit
//
//  Created by Рамиз Кичибеков on 02.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import Foundation

public enum HTTPError: Error, CustomStringConvertible {
    
    case validation(statusCode: Int, response: CustomStringConvertible?)
    case server(error: ServerError, httpStatusCode: Int?)
    case parsing(response: CustomStringConvertible?)
    
    public var description: String {
        var description = ""
        
        switch self {
        case let .validation(statusCode, response):
            description = "Response: \(response ?? "Unresolved data.")" + "\nStatus code: \(statusCode)"
            
        case let .server(error, httpStatusCode):
            description = "Server error: \(error.description). Code: \(error.сode)."
            
            if httpStatusCode != nil {
                description += " HTTP status: \(httpStatusCode!)"
            }
            
            if error.debugMessage != nil {
                description += "\nDebug message: \(error.debugMessage!)"
            }
            
            if error.details != nil {
                description += "\nDetails: \(error.details!)"
            }
            
        case let .parsing(response):
            description = "Response: \(response ?? "Unresolved data.")"
        }
        
        return description
    }
}

public class ErrorManager {
    
    static func alertBody(for error: Error) -> String {
        var body = ""
        if let error = error as? HTTPError {
            body = httpErrorBody(for: error)
        } else {
            let error = error as NSError
            if error.code == -1009 {
                body = "Check your Internet connection"
            }
        }
        return body
    }
    
    private static func httpErrorBody(for httpError: HTTPError) -> String {
        var body = ""
        switch httpError {
        case let .validation(statusCode, _):
            body = statusCodeBody(for: statusCode)
        case let .server(error, _):
            body = error.description
        default:
            body = "Try again later"
        }
        return body
    }
    
    private static func statusCodeBody(for statusCode: Int) -> String {
        return "Try again later"
    }
}
