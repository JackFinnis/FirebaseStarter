//
//  User.swift
//  Ecommunity
//
//  Created by Jack Finnis on 20/09/2021.
//

import Foundation

struct User: Identifiable, Equatable {
    let id: String
    let lastName: String?
    let firstName: String?
    
    var name: String { (firstName ?? "nil") + " " + (lastName ?? "nil") }
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.lastName = data["lastName"] as? String
        self.firstName = data["firstName"] as? String
    }
}
