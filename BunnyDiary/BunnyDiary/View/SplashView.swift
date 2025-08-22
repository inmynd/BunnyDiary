//
//  SplashView.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/22/25.
//

import SwiftUI

struct SplashView: View {
    // 이미지 전환을 위한 상태 변수
    @State private var showMouth = false
    
    var duration: TimeInterval = 1.6
    var onFinished: () -> Void = {}
    
    var body: some View {
        Image(showMouth ? "SplashBunny" : "EyesBunny")
            .resizable()
            .scaledToFit()
            .frame(height: 240)
            .animation(.easeInOut(duration: 0.5), value: showMouth)
            .padding()
            .onAppear {
                // 디스패치큐~
                DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.5) {
                    withAnimation { showMouth = true }
                }
                // 전체 duration 후 라우터에 알ㄹㅕ줘서 넘어가는거임
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    onFinished()
                }
            }
    }
}

#Preview {
    SplashView()
}
