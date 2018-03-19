//
//  StoriesManager.swift
//  HackerNewsKit
//
//  Created by Рамиз Кичибеков on 02.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import Foundation

public enum ContentType: Int {
    case newStories
    case topStories
    case bestStories
    
    public var description: String {
        switch self {
        case .newStories: return "New Stories"
        case .topStories: return "Top Stories"
        case .bestStories: return "Best Stories"
        }
    }
    
    var jsonString: String {
        switch self {
        case .newStories: return "newstories.json"
        case .topStories: return "topstories.json"
        case .bestStories: return "beststories.json"
        }
    }
}

public class StoriesManager {
        
    private static let serverURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
    
    public class func getStories(_ contentType: ContentType, completionHandler: @escaping RequestBlock) {
        getRequest(contentType.jsonString, parameters: nil, completionHandler: completionHandler)
    }
    
    public class func getStory(_ storyID: Int, completionHandler: @escaping RequestBlock) {
        getRequest("item/\(storyID).json", parameters: nil, completionHandler: completionHandler)
    }
    
    //MARK: - Private methods
    
    private class func absolutePath(_ relativePath: String) -> URL {
        guard !relativePath.isEmpty else {
            return serverURL
        }
        if relativePath.first == "/" {
            print("!!Warning: '/' symbol at the begining of url relativePath will cause 'RestrictedIP' error")
        }
        return URL(string: relativePath, relativeTo: serverURL)!
    }
    
    private class func executeRequest(_ request: URLRequest, completionHandler: @escaping RequestBlock) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                let error = HTTPError.parsing(response: nil)
                print("Request '\(request.url?.path ?? "")', '\(request.httpMethod ?? "")' [-]")
                return completionHandler(nil, error)
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                let error = HTTPError.parsing(response: data)
                print("Request '\(request.url?.path ?? "")', '\(request.httpMethod ?? "")' [-]")
                return completionHandler(nil, error)
            }
            
            if let error = ServerError(rawResponse: json) {
                let httpResponse = response as? HTTPURLResponse
                let httpStatusCode = httpResponse?.statusCode
                let error = HTTPError.server(error: error, httpStatusCode: httpStatusCode)
                print("Request '\(request.url?.path ?? "")', '\(request.httpMethod ?? "")' [-]")
                return completionHandler(nil, error)
            }
            
            if  let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                let error = HTTPError.validation(statusCode: httpResponse.statusCode, response: json as? CustomStringConvertible)
                print("Request '\(request.url?.path ?? "")', '\(request.httpMethod ?? "")' [-]")
                return completionHandler(nil, error)
            }
            
            print("Request '\(request.url?.path ?? "")', '\(request.httpMethod ?? "")' [+]")
            completionHandler(json, nil)
        }.resume()
    }
    
    private class func getRequest(_ path: String, parameters: JSON?, completionHandler: @escaping RequestBlock) {
        var queryItem = [URLQueryItem]()
        if let parameters = parameters {
            for (key, value) in parameters {
                queryItem.append(URLQueryItem(name: key, value: String(describing: value)))
            }
        }
        var urlComponents = URLComponents(url: absolutePath(path), resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = queryItem.filter{!$0.name.isEmpty}
        
        let request = URLRequest(url: urlComponents.url!)
        executeRequest(request, completionHandler: completionHandler)
    }
    
}
