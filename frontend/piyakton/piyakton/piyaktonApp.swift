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
    
    private var container: DIContainer {
        DIContainer(firestore: appDelegate.database!)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: .init(container: container))
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
    
    init(firestore: Firestore) {
            let userRepository = UserRepositoryImpl()
            self.userService = UserServiceImpl(userRepository: userRepository)
            
            // Pass Firestore instance to TaskRepository
            let taskRepository = TaskRepository(db: firestore)
            self.taskService = TaskService(repository: taskRepository)
        }
}
