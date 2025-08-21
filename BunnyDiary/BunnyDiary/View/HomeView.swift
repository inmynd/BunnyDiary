//
//  ContentView.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \ThanksDiary.date, order: .reverse)
    private var diaries: [ThanksDiary]
    
    var body: some View {
        let hasEntries = !diaries.isEmpty
        let bunnyName = hasEntries ? "MainBunny" : "SmileBunny"
        VStack {
            Text(Date().formatted(.dateTime.year().month().day().weekday(.wide).locale(Locale(identifier: "ko_KR"))))
                .font(.Bunny40)
            Image(bunnyName)
                .resizable()
                .scaledToFit()
                .padding(.all)
            Text(hasEntries ? "오늘의 감사를\n함께 나눌 수 있어\n감사해요!" : "오늘의 감사한 일을\n세줄로\n기록해보세요!")
                .multilineTextAlignment(.center)
                .font(.Bunny40)
            HStack{
                MainButton(icon: "WriteIcon", title: "세줄감사쓰기") {}
                MainButton(icon: "ReadIcon", title: "세줄감사") {}
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
