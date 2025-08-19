//
//  WriteView.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//

import SwiftUI

struct WriteView: View {
    var body: some View {
        VStack{
            Image("MainBunny")
                .resizable()
                .frame(width: 100, height: 100)
            Text("오늘의 감사한 일을 작성해주세요!")
                .font(.Bunny35)
            
        }
    }
}

#Preview {
    WriteView()
}
