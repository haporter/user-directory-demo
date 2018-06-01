//
//  Individual.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/24/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Individual: Object, Codable {
    
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
    
    @objc dynamic private var _id: Int = 0
    var id: String {
        return String(_id)
    }
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var birthdate: String = ""
    @objc private var profilePictureURLString: String = ""
    var profileImage: UIImage? = nil
    @objc dynamic var forceSensitive: Bool = false
    @objc dynamic private var _affiliation: String = ""
    var affiliation: Affiliation {
        return Affiliation(affiliation: _affiliation)
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case _id = "id"
        case firstName
        case lastName
        case birthdate
        case profilePictureURLString = "profilePicture"
        case forceSensitive
        case _affiliation = "affiliation"
    }
    
    convenience init(id: Int,
         firstName: String,
         lastName: String,
         birthdate: String,
         profilePicURLString: String,
         forceSensitive: Bool,
         affiliation: String) {
        self.init()
        
        self._id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
        self.profilePictureURLString = profilePicURLString
        self.forceSensitive = forceSensitive
        self._affiliation = affiliation
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        let id = try! container.decode(Int.self, forKey: ._id)
        let firstName = try! container.decode(String.self, forKey: .firstName)
        let lastName = try! container.decode(String.self, forKey: .lastName)
        let birthdate = try! container.decode(String.self, forKey: .birthdate)
        let picURL = try! container.decode(String.self, forKey: .profilePictureURLString)
        let forceSensitive = try! container.decode(Bool.self, forKey: .forceSensitive)
        let affiliation = try! container.decode(String.self, forKey: ._affiliation)
        
        self.init(id: id, firstName: firstName, lastName: lastName, birthdate: birthdate, profilePicURLString: picURL, forceSensitive: forceSensitive, affiliation: affiliation)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    func getProfileImage() {
        guard let imageURL = URL(string: profilePictureURLString),
              let data = try? Data(contentsOf: imageURL),
              let image = UIImage(data: data) else {
                return
        }
        self.profileImage = image
    }
    
    func imageLoadOperation() -> ImageLoadOperation? {
        if profileImage != nil { return nil }
        
        return ImageLoadOperation(self)
    }
}











