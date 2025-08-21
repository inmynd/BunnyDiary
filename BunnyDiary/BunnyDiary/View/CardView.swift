//
//  CardView.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//

import SwiftUI
import SwiftData

struct CardView: View {
    let item: ThanksDiary
    var onGoHome: () -> Void = {}
    //\. dismiss 뷰닫기
    
    var body: some View {
        VStack {
            Image(.smileBunny)
                .padding()
            Text(Date().formatted(.dateTime.year().month().day().weekday(.wide).locale(Locale(identifier: "ko_KR"))))
                .font(.Bunny40)
            
            VStack(alignment: .leading, spacing: 28) {
                if !item.line1.isEmpty {
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Image("Carrot")
                        Text(item.line1)
                            .font(.Bunny30)
                    }
                }
                if !item.line2.isEmpty {
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Image("Carrot")
                        Text(item.line2)
                            .font(.Bunny30)
                    }
                }
                if !item.line3.isEmpty {
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Image("Carrot")
                        Text(item.line3)
                            .font(.Bunny30)
                    }
                }
            }
            .padding(24)
            .frame(width: 353, height:295, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 24).fill(Color("BunnyGray")))
            
            Button(action: { onGoHome() }) {
                Text("홈화면으로 가기")
                    .font(.Bunny30)
                    .foregroundStyle(.bunnyBlack)
                    .frame(width: 353, height: 85)
                    .background(.bunnyPink)
                    .clipShape(.buttonBorder)
            }
            .padding(.top, 30)
        }
        .padding()
    }
}

#Preview {
    CardView(item: ThanksDiary(line1: "오늘도 맑음", line2: "아침 운동을 했다!", line3: "새벽예배에 다녀왔다!", date: Date()))
}
