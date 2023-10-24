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
                                        param: nil) { response in
            DispatchQueue.main.async {
                // Codable
                Utilize.shared.validateModel(model: [User].self,
                                             data: response, fun: "getUserList") { data in
                    self.users = data
                }
                // JSONSerialization
                if let jsonObject = try? JSONSerialization.jsonObject(with: response, options: []) as? [[String: Any]] {
                    for jsonObject in jsonObject {
                        if let name = jsonObject["name"] as? String,
                            let id = jsonObject["id"] as? Int {
                            self.users2.append(User(id: id, name: name, username: "", email: "", address: nil, phone: "", website: "", company: nil))
                        }
                    }
                }
            }
        }
    }
}
