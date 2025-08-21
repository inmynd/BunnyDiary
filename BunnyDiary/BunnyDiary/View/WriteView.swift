//
//  WriteView.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//

import SwiftUI
import SwiftData

struct WriteView: View {
    @Environment(\.modelContext) private var context
    @State private var lineOne: String = ""
    @State private var lineTwo: String = ""
    @State private var lineThree: String = ""
    
    var onSaved: (ThanksDiary) -> Void = { _ in }
    
    var body: some View {
        VStack{
            Image("MainBunny")
                .resizable()
                .frame(width: 100, height: 100)
            Text("오늘의 감사한 일을 작성해주세요!")
                .font(.Bunny35)
                .padding()
            DiaryTextField(text: $lineOne, placeholder: "한줄감사")
            DiaryTextField(text: $lineTwo, placeholder: "두줄감사")
            DiaryTextField(text: $lineThree, placeholder: "세줄감사")
            
            SaveButton(
                title: "세줄감사 저장하기",
                isEnabled: Binding(get: {
                    !(lineOne.isEmpty || lineTwo.isEmpty || lineThree.isEmpty)
                }, set: { _ in })            ) {
                // 아래부터 SwiftData 저장로직
                let item = ThanksDiary(line1: lineOne, line2: lineTwo, line3: lineThree, date: Date())
                context.insert(item)
                do {
                    try context.save()
                    onSaved(item)
                } catch {
                    print("Save failed: \(error)")
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    WriteView()
}
