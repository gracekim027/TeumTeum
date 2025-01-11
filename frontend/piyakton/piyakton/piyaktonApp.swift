//
//  piyaktonApp.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

@main
struct piyaktonApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private let container: DIContainer
    
    init() {
        self.container = .init()
    }
    
    var body: some Scene {
        WindowGroup {
            //MainView(viewModel: .init(container: container))
            ArticleDetailView(todoGroup: .debug1, selected: 0)
                .background(Color.darkBackground.ignoresSafeArea(.all))
        }
    }
}

final class PathState: ObservableObject {
    @Published var path: NavigationPath
    
    init() {
        self.path = .init()
    }
}

final class DIContainer {
    let userService: UserService
    
    init() {
        let userRepository = UserRepositoryImpl()
        self.userService = UserServiceImpl(userRepository: userRepository)
    }
}
