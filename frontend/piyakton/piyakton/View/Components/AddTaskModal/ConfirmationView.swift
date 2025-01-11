//
//  ConfirmationView.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct ConfirmationView: View {
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onClose()
                }
            
            VStack(spacing: 24) {
                Text("✅")
                    .font(.system(size: 50))
                
                VStack(spacing: 8) {
                    Text("틈새자료가 완료되면 알림을 보내드릴게요")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Text("1분에서 5분 정도 소요되어요")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: onClose) {
                    Text("홈으로 돌아가기")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(24)
            .frame(width: 345, alignment: .center)
            .background(Color.white)
            .cornerRadius(16)
        }
    }
}
