//
//  piyaktonApp.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore

@main
struct piyaktonApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: .init(container: .init(db: appDelegate.database!)))
          //ArticleDetailView(todoGroup: .debug1, selected: 0)
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
    let taskService: TaskService
    
    init(db: Firestore) {
        let userRepository = UserRepositoryImpl()
        self.userService = UserServiceImpl(userRepository: userRepository)
        
        let taskRepository = TaskRepository(db: db)
        self.taskService = TaskService(repository: taskRepository)
    }
}
