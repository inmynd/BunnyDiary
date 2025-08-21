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
    @Binding var isEnabled: Bool
    let action: () -> Void
    //클로저를 만들어서 쓰고 있는 것
    
    var body: some View {
        Button(action: action)
        {
            Text(title)
                .font(.Bunny30)
                .foregroundStyle(isEnabled ? Color("BunnyBlack") : Color("BunnyGray"))
        }
        .frame(width: 353, height: 85)
        .background(isEnabled ? Color("BunnyPink") : Color("BunnyGray"))
        .clipShape(.buttonBorder)
        .disabled(!isEnabled)
    }
}
