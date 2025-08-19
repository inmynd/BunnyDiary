//
//  SaveButton.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/19/25.
//
import SwiftUI
import SwiftData

struct SaveButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action)
        {
            Text(title)
                .font(.Bunny30)
                .foregroundStyle(.bunnyBlack)
        }
        .frame(width: 353, height: 85)
        .background(Color("BunnyPink"))
        .clipShape(.buttonBorder)
        
    }
}

#Preview {
    SaveButton(title: "세줄감사 저장하기") {
        
    }
}
