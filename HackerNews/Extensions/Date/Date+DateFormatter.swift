//
//  Date+DateFormatter.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 02.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import Foundation

extension Date {
    static func correctDate(_ date: Date) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateStyle = .short
        
        return dateFormatter.date(from: dateFormatter.string(from:date))
    }
}
