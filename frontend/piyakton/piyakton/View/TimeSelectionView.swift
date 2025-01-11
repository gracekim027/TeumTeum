//
//  TimeSelectionView.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct TimeSelectionView: View {
    
    @Binding var isPresented: Bool
    @Binding var selectedTime: Int?
    let onTimeSelected: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            VStack(spacing: 8) {
                Text("⏰")
                    .font(.header1Bold)
                
                Text("몇 분으로 쪼개\n학습하고 싶으신가요?")
                    .foregroundStyle(Color.gray900)
                    .font(.header2Bold)
            }
            
            VStack(spacing: 12) {
                TimeOptionButton(
                    minutes: 3,
                    description: "짧은 틈에 빠르게",
                    emoji: "🐰",
                    background: .lime600,
                    action: {
                        selectedTime = 3
                        isPresented = false
                        onTimeSelected()
                    }
                )
                
                TimeOptionButton(
                    minutes: 5,
                    description: "적당한 틈에 부담없이",
                    emoji: "🐱",
                    background: .orange600,
                    action: {
                        selectedTime = 5
                        isPresented = false
                        onTimeSelected()
                    }
                )
                
                TimeOptionButton(
                    minutes: 10,
                    description: "넉넉한 틈에 여유롭게",
                    emoji: "🐢",
                    background: .coral600,
                    action: {
                        selectedTime = 10
                        isPresented = false
                        onTimeSelected()
                    }
                )
            }
        }
        .padding(24)
        .frame(width: 345)
        .background(Color.whiteOpacity800)
        .cornerRadius(16)
        .blur(radius: CustomBlur.medium.radius)
    }
}
