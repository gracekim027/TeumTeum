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
        ZStack {
            // Blur background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            // Popup content
            VStack(alignment: .center, spacing: 24) {
                VStack(spacing: 8) {
                    Text("⏰")
                        .font(.system(size: 40))
                    
                    Text("몇 분으로 쪼개")
                        .font(.title2)
                        .bold()
                    Text("학습하고 싶으신가요?")
                        .font(.title2)
                        .bold()
                }
                
                VStack(spacing: 16) {
                    TimeOptionButton(
                        minutes: 3,
                        description: "짧은 틈에 빠르게",
                        emoji: "🐰",
                        isSelected: selectedTime == 3,
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
                        isSelected: selectedTime == 5,
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
                        isSelected: selectedTime == 10,
                        action: {
                            selectedTime = 10
                            isPresented = false
                            onTimeSelected()
                        }
                    )
                }
            }
            .padding(24)
            .frame(width: 345, alignment: .top)
            .background(Color.white.opacity(0.8))
            .cornerRadius(16)
        }
    }
}

