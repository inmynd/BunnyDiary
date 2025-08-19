//
//  TextField.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/19/25.
//

import SwiftUI

struct DiaryTextField: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        TextField(placeholder, text:$text)
        .font(.Bunny30)
        .frame(width: 353, height: 85)
        .background(Color("BunnyGray"))
        .clipShape(.buttonBorder)
        .multilineTextAlignment(.center)
        .onChange(of: text) { _, newValue in
            limitText(value: newValue)
        }
        .foregroundStyle(.bunnyBlack)
    }
    
    
    private func limitText(value: String) {
        if value.count > 20 {
            text = String(value.prefix(20))
        }
    }
}


//프리뷰용
private struct TFPreview: View {
    @State private var diaryText: String = ""
    
    var body: some View {
        DiaryTextField(text: $diaryText, placeholder: "한줄감사")
            .padding()
    }
}

#Preview {
    TFPreview()
}
