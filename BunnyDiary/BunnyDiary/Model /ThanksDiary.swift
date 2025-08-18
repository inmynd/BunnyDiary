//
//  ThanksDiary.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//

import SwiftData
import Foundation

@Model
final class ThanksDiary {
    var line1: String
    var line2: String
    var line3: String
    var date: Date
    
    init(line1: String, line2: String, line3: String, date: Date = .now) {
        self.line1 = line1
        self.line2 = line2
        self.line3 = line3
        self.date = date
    }
}
