//
//  TimeSelectionView.swift
//  TeumTeum
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct TimeSelectionView: View {
    
    @Binding var isPresented: Bool
    @Binding var selectedTime: RequiredTime?
    let select: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            VStack(spacing: 8) {
                Text("⏰")
                    .font(.header1Bold)
                
                Text("몇 분으로 쪼개\n학습하고 싶으신가요?")
                    .foregroundStyle(Color.gray900)
                    .font(.header2Bold)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                TimeSelectionButton(
                    requiredTime: .short,
                    action: {
                        selectedTime = .short
                        isPresented = false
                        select()
                    }
                )
                
                TimeSelectionButton(
                    requiredTime: .medium,
                    action: {
                        selectedTime = .medium
                        isPresented = false
                        select()
                    }
                )
                
                TimeSelectionButton(
                    requiredTime: .long,
                    action: {
                        selectedTime = .long
                        isPresented = false
                        select()
                    }
                )
            }
        }
        .padding(24)
        .frame(width: 345)
        .background(Color.whiteOpacity900)
        .cornerRadius(16)
    }
}
