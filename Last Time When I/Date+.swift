//
//  Date+.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 03/01/2022.
//  Copyright © 2022 zhihaocui. All rights reserved.
//

import Foundation

extension Date {
    
    func relativeToNow() -> String {
        let relativeDateTimeFormatter = RelativeDateTimeFormatter()
        return relativeDateTimeFormatter.localizedString(for: self, relativeTo: Date())
    }
}
