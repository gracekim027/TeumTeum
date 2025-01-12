//
//  ChatView.swift
//  piyakton
//
//  Created by 최유림 on 1/12/25.
//

import SwiftUI

struct ChatView: View {
    
    @Binding var chatList: [Chat]
    
    @State private var currentMessage: String = ""
    @State private var lastMessageId: Int?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    ScrollView(.vertical) {
                        VStack(spacing: 32) {
                            ForEach(chatList, id: \.self) { chat in
                                chatBubbleGroup(received: chat.received, chat)
                                    .id(chat.hashValue)
                            }
                        }
                    }
                }
                .padding(.vertical, 32)
                .onChange(of: chatList) { _, newList in
                    if let id = newList.last?.hashValue {
                        proxy.scrollTo(id)
                    }
                }
                
                MessageField(text: $currentMessage, placeholder: "궁금한 걸 자유롭게 입력해주세요") {
                    guard let lastChat = chatList.last else { return }
                    if lastChat.received {
                        let newChat = Chat(received: false, content: [currentMessage])
                        chatList.append(newChat)
                    } else {
                        chatList[chatList.count - 1].appendChat(currentMessage)
                    }
                    currentMessage = ""
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
            .background(
                Image("gradient").clipped()
            )
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("닫기")
                            .font(.body1Medium)
                            .foregroundStyle(Color.whiteOpacity700)
                    }
                }
            }
            .background(Color.darkBackground.ignoresSafeArea(.all))
        }
    }
}

extension ChatView {
    @ViewBuilder private func chatBubbleGroup(received: Bool, _ chat: Chat) -> some View {
        HStack(alignment: .top, spacing: 0) {
            if received {
                Image("teumteum")
                Spacer().frame(width: 8)
            } else {
                Spacer()
            }
            VStack(alignment: received ? .leading : .trailing, spacing: 6) {
                ForEach(chat.content, id: \.self) { message in
                    textBox(received: received, message)
                }
            }
            if received {
                Spacer()
            }
        }
    }
    
    @ViewBuilder private func textBox(received: Bool, _ content: String) -> some View {
        Text(content)
            .font(.body1Regular)
            .foregroundStyle(received ? .white : Color.gray900)
            .multilineTextAlignment(.leading)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(received ? Color.grayOpacity800 : .white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
