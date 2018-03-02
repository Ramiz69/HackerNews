//
//  Story.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 26.02.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import Foundation

enum CodingKeys: String, CodingKey {
    case id = "id"
    case title = "title"
    case author = "author"
    case date = "date"
    case url = "url"
    case text = "text"
}

final class Story: Codable {
    
    let id: Int
    let title: String
    let author: String
    let date: TimeInterval
    let url: String
    let text: String
    
    convenience init?(_ rawResponse: [String: Any]) {
        guard
            let id = rawResponse["id"] as? Int,
            let title = rawResponse["title"] as? String,
            let author = rawResponse["by"] as? String,
            let date = rawResponse["time"] as? TimeInterval,
            let url = rawResponse["url"] as? String
            else {
                return nil
        }
        
        self.init(id: id,
                  title: title,
                  author: author,
                  date: date,
                  url: url,
                  text: rawResponse["text"] as? String ?? "")
    }
    
    init(id: Int,
         title: String,
         author: String,
         date: TimeInterval,
         url: String,
         text: String) {
        
        self.id = id
        self.title = title
        self.author = author
        self.date = date
        self.url = url
        self.text = text
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        author = try values.decode(String.self, forKey: .author)
        date = try values.decode(TimeInterval.self, forKey: .date)
        url = try values.decode(String.self, forKey: .url)
        text = try values.decode(String.self, forKey: .text)
    }
}
