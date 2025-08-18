//
//  BunnyFont.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//

import SwiftUI

extension Font {
    static func bunny(size: CGFloat) -> Font
    {
        .custom("NanumJungHagSaeng", size: size)
    }
    
    static var Bunny40: Font {.bunny(size: 40)}
    static var Bunny35: Font {.bunny(size: 35)}
    static var Bunny30: Font {.bunny(size: 30)}
    static var Bunny21: Font {.bunny(size: 21)}
    
}
