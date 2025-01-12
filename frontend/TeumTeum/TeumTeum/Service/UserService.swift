//
//  UserService.swift
//  TeumTeum
//
//  Created by 최유림 on 1/11/25.
//

import Foundation

protocol UserService {
    
}

final class UserServiceImpl: UserService {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    
}
