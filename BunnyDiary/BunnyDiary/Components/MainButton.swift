//
//  MainButton.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//
import SwiftUI

struct MainButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action)
        {
            VStack(spacing: 10) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)
                    .foregroundStyle(.bunnyBlack)
                Text(title)
                    .font(.Bunny30)
                    .foregroundStyle(.bunnyBlack)
            }
            .frame(width: 167, height: 151)
            .background(Color("BunnyPink"))
            .clipShape(.buttonBorder)
                
            }
        }
    }

