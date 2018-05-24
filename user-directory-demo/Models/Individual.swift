//
//  Individual.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/24/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import Foundation

class Individual: Codable {
    
    enum Affiliation: String {
        case jedi = "Jedi"
        case resistance = "Resistance"
        case firstOrder = "First Order"
        case sith = "Sith"
        case joeShmo = "Joe Shmo"
        
        init(affiliation: String) {
            switch affiliation.lowercased() {
            case "jedi":
                self = .jedi
            case "resistance":
                self = .resistance
            case "first_order":
                self = .firstOrder
            case "sith":
                self = .sith
            default:
                self = .joeShmo
            }
        }
    }
    
    let id: Int
    let firstName: String
    let lastName: String
    let birthdate: String
    private let profilePictureURLString: String
    let forceSensitive: Bool
    private let _affiliation: String
    var affiliation: Affiliation {
        get {
            return Affiliation(affiliation: _affiliation)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case birthdate
        case profilePictureURLString = "profilePicture"
        case forceSensitive
        case _affiliation = "affiliation"
    }
    
    init(id: Int,
         firstName: String,
         lastName: String,
         birthdate: String,
         profilePicURLString: String,
         forceSensitive: Bool,
         affiliation: String) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
        self.profilePictureURLString = profilePicURLString
        self.forceSensitive = forceSensitive
        self._affiliation = affiliation
    }
}
