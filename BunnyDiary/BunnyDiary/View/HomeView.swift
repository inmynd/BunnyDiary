//
//  ContentView.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text(Date().formatted(.dateTime.year().month().day().weekday(.wide).locale(Locale(identifier: "ko_KR"))))
                .font(.Bunny40)
            Image(.mainBunny)
            Text("오늘의 감사한 일을\n세줄로\n기록해보세요!")
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
