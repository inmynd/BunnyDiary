//
//  BunnyDiaryApp.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//

import SwiftUI
import SwiftData

@main
struct BunnyDiaryApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView()
                .modelContainer(for: ThanksDiary.self)
                .preferredColorScheme(.light)
        }
    }
}
