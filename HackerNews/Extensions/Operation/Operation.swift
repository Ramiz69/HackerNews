//
//  Operation.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 05.03.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import Foundation

extension Operation {
    func cancelOperation() {
        if isCancelled {
            return
        }
    }
}
