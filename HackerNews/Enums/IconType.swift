//
//  IconType.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 01.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import Foundation

enum IconType: Int {
    case newStories
    case topStories
    case bestStories
    
    var description: String {
        switch self {
        case .newStories: return "New"
        case .topStories: return "Apple"
        case .bestStories: return "Panda"
        }
    }
}
