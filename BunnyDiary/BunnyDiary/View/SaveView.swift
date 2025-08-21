//
//  SaveView.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/20/25.
//

import SwiftUI

struct SaveView: View {
    @State private var save: Bool = false
    let delay: Double = 0.8
    var onFinished: () -> Void = {}

    var body: some View {
        VStack(spacing: 16) {
            Image(save ? "SaveBunnyFill" : "SaveBunnyBlank")
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .contentTransition(.opacity)

            Text(save ? "세줄감사 저장 완료!" : "세줄감사 저장 중 ...")
                .font(.Bunny40)
                .foregroundStyle(.bunnyBlack)
                .transition(.opacity)
        }
        .animation(.easeInOut(duration: 0.3), value: save)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation { save = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.6) {
                onFinished()
            }
        }
    }
}

#Preview {
    SaveView()
}
