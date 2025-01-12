//
//  MainViewModel.swift
//  TeumTeum
//
//  Created by 최유림 on 1/11/25.
//

import Foundation


final class MainViewModel: ViewModel, ObservableObject {
    
    @Published var todoGroupList: [TodoGroup] = [.debug1, .dummyData]
    
    override init(container: DIContainer) {
        super.init(container: container)
    }
    
    func fetchTodoGroupList() async {
        do {
            let groupList = try await container.taskService.fetchTodoGroup()
            todoGroupList = todoGroupList
        } catch {
            print(error)
        }
    }
}
