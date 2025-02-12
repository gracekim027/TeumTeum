//
//  TeumTeumApp.swift
//  TeumTeum
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore

@main
struct TeumTeumApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView(viewModel: .init(container: .init(db: appDelegate.database!)))
                    .background(Color.darkBackground)
                    .preferredColorScheme(.dark)
            }
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
    let taskService: TaskService
    
    init(db: Firestore) {
        let userRepository = UserRepositoryImpl()
        self.userService = UserServiceImpl(userRepository: userRepository)
        
        let taskRepository = TaskRepository(db: db)
        self.taskService = TaskService(repository: taskRepository, storageService: .init())
    }
}
