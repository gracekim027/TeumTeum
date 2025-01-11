//
//  piyaktonApp.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

@main
struct piyaktonApp: App {
    
    private let container: DIContainer
    
    init() {
        self.container = .init()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
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
