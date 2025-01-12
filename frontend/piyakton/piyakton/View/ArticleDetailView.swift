//
//  ArticleDetailView.swift
//  piyakton
//
//  Created by 최유림 on 1/12/25.
//

import SwiftUI
import Combine
import AVFoundation

struct ArticleDetailView: View {
    
    let todoGroup: TodoGroup
    let selected: Int
    
    private var article: Article {
        todoGroup.articleList![selected]
    }
    
    private var progressRate: CGFloat {
        CGFloat(todoGroup.unitTime.rawValue * 60 - remainingSec) / CGFloat(todoGroup.unitTime.rawValue * 60)
    }
    
    init(todoGroup: TodoGroup, selected: Int) {
        self.todoGroup = todoGroup
        self.selected = selected
        self.remainingSec = todoGroup.unitTime.rawValue * 60
    }
    
    @State private var isPlaying: Bool = false
    @State private var onTap: Bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var currentTimer: Cancellable?
    @State private var remainingSec: Int
    @State private var player: AVPlayer?
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Button {
                            // edit action
                        } label: {
                            HStack(spacing: 0) {
                                Image("chevron-left")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("홈으로")
                                    .font(.body1Medium)
                                    .foregroundStyle(Color.whiteOpacity700)
                                    .padding(.vertical, 4)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .frame(height: 44)
                    
                    // progress bar
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(width: progressRate * proxy.size.width, height: 2)
                            .foregroundStyle(Color.lime600)
                        Spacer()
                    }
                    .background(Color.gray900)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    
                    Spacer().frame(height: 34)
                    
                    VStack(spacing: 48) {
                        headerSection()
                        summarySection()
                        recommendSection()
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 92)
                    
                    HStack {
                        Spacer()
                        Button {
                            // send feedback
                        } label: {
                            Text("개발자에게 의견 보내기")
                                .font(.body2Medium)
                                .foregroundStyle(Color.whiteOpacity600)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .background(Color.whiteOpacity100)
                                .clipShape(RoundedRectangle(cornerRadius: 100))
                        }
                        Spacer()
                    }
                    
                    Spacer().frame(height: 98)
                    
                    HStack {
                        Spacer()
                        Button {
                            // start chatting
                        } label: {
                            HStack(spacing: 4) {
                                Image("eyes")
                                Text("틈틈에게 질문하기")
                                    .font(.body1Medium)
                                    .foregroundStyle(.black)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.lime600)
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                        }
                        Spacer().frame(width: 24)
                    }
                }
            }
            .onAppear {
                isPlaying = true
            }
            // timer
            .onReceive(timer) { _ in
                if remainingSec > 0 {
                    remainingSec -= 1
                } else {
                    currentTimer?.cancel()
                }
            }
            .onChange(of: isPlaying) { _, newValue in
                if newValue {
                    playAudio()
                    currentTimer?.cancel()
                    timer = Timer.publish(every: 1, on: .main, in: .common)
                    currentTimer = timer.connect()
                } else {
                    pauseAudio()
                    currentTimer?.cancel()
                }
            }
        }
    }
}

extension ArticleDetailView {
    @ViewBuilder private func headerSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            RequiredTimeChip(requiredTime: todoGroup.unitTime)
            
            Spacer().frame(height: 16)
            
            if let title = todoGroup.title {
                Text(title)
                    .font(.body1SemiBold)
                    .foregroundStyle(Color.gray300)
                
                Spacer().frame(height: 6)
            }
            
            HStack(alignment: .top, spacing: 0) {
                Text(article.title)
                    .font(.display2SemiBold)
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    isPlaying.toggle()
                } label: {
                    Image(isPlaying ? "pause" : "play")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.top, 6)
                }
                .buttonStyle(ScalingButtonStyle())
            }
            
            Spacer().frame(height: 24)
            
            // MARK: summary
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("틈새 한 줄 요약")
                        .font(.title3SemiBold)
                        .foregroundStyle(Color.lime600)
                    Spacer()
                }
                
                Text(article.summary)
                    .font(.body1Regular)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color.gray900)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    @ViewBuilder private func summarySection() -> some View {
        VStack(alignment: .leading, spacing: 44) {
            ForEach(article.content) { content in
                VStack(alignment: .leading, spacing: 12) {
                    Text(content.title)
                        .font(.title1Bold)
                        .foregroundStyle(.white)
                    
                    Text(content.body)
                        .font(.body1Regular)
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    @ViewBuilder private func recommendSection() -> some View {
        VStack(alignment: .leading, spacing: 40) {
            
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.whiteOpacity300)
            
            
        }
    }
}

extension ArticleDetailView {
    private func playAudio() {
        guard let url = Bundle.main.url(forResource: "hashing_audio", withExtension: "mp3")
        //guard let url = URL(string: "example")
         else {
            return
        }
        player = AVPlayer(url: url)
        player?.play()
    }
    
    private func pauseAudio() {
        player?.pause()
    }
}

struct ScalingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.interactiveSpring, value: configuration.isPressed)
    }
}
