//
//  HomeViewModel.swift
//  Sample-MVVM-Swift
//
//  Created by Chhan Sophearith on 23/10/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var users: [User]?
    @Published var users2: [User] = []
    
    func getUserList() {
        ApiManager.shared.apiConnection(url: ApiEndPoint.getUsers.rawValue,
                                        method: .GET,
                                        param: nil) { (data: [User]) in
            DispatchQueue.main.async {
                self.users = data
            }
        }
    }
}
