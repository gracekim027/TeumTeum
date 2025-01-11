//
//  piyaktonApp.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct piyaktonApp: App {
    
    private let container: DIContainer
    
    init() {
        self.container = .init()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView(viewModel: .init(container: container))
        }
    }
}

final class DIContainer {
    let userService: UserService
    
    init() {
        let userRepository = UserRepositoryImpl()
        self.userService = UserServiceImpl(userRepository: userRepository)
    }
}
