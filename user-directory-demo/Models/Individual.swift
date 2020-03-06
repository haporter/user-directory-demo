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
        case jedi = "jedi"
        case resistance = "resistance"
        case firstOrder = "first_order"
        case sith = "sith"
        case joeShmo = "Joe Shmo"
        
        var description: String {
            var description = ""
            switch self {
            case .jedi:
                description = "Jedi"
            case .resistance:
                description = "Resistance"
            case .firstOrder:
                description = "First Order"
            case .sith:
                description = "Sith"
            case .joeShmo:
                description = "Joe Shmoe"
            }
            return description
        }
        
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
        
        init(int: Int) {
            switch int {
            case 1:
                self = .jedi
            case 2:
                self = .resistance
            case 3:
                self = .firstOrder
            case 4:
                self = .sith
            default:
                self = .joeShmo
            }
        }
    }
    
    @objc dynamic var id: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var birthdate: String = ""
    @objc dynamic var profilePictureURLString: String = ""
    @objc dynamic var profileImageFileURL: String = ""
    @objc dynamic var forceSensitive: Bool = false
    @objc private dynamic var _affiliation: String = ""
    var affiliation: Affiliation {
        return Affiliation(affiliation: _affiliation)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName
        case lastName
        case birthdate
        case profilePictureURLString = "profilePicture"
        case forceSensitive
        case _affiliation = "affiliation"
    }
    
    convenience init(id: String,
         firstName: String,
         lastName: String,
         birthdate: String,
         profilePicURLString: String,
         forceSensitive: Bool,
         affiliation: String) {
        self.init()
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
        self.profilePictureURLString = profilePicURLString
        self.forceSensitive = forceSensitive
        self._affiliation = affiliation
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        let id = try! container.decode(Int.self, forKey: .id)
        let firstName = try! container.decode(String.self, forKey: .firstName)
        let lastName = try! container.decode(String.self, forKey: .lastName)
        let birthdate = try! container.decode(String.self, forKey: .birthdate)
        let picURL = try! container.decode(String.self, forKey: .profilePictureURLString)
        let forceSensitive = try! container.decode(Bool.self, forKey: .forceSensitive)
        let affiliation = try! container.decode(String.self, forKey: ._affiliation)
        
        self.init(id: String(id), firstName: firstName, lastName: lastName, birthdate: birthdate, profilePicURLString: picURL, forceSensitive: forceSensitive, affiliation: affiliation.lowercased())
    }
    
    required init() {
        super.init()
    }
    
    func getProfileImage() {
        guard let imageURL = URL(string: profilePictureURLString) else { return }
        do {
            let data = try Data(contentsOf: imageURL)
            let image = UIImage(data: data)
            saveImageToDocs(image)
        } catch let error {
            print(error)
        }
        
    }
    
    func imageLoadOperation() -> ImageLoadOperation? {
        if !profileImageFileURL.isEmpty { return nil }
        
        let individualRef = ThreadSafeReference(to: self)
        
        return ImageLoadOperation(individualRef)
    }
    
    private func saveImageToDocs(_ image: UIImage?) {
        if let image = image, let jpegData = image.jpegData(compressionQuality: 0.8) {
            let filePath = getDocumentsDirectory().appendingPathComponent(self.firstName + self.lastName + ".jpeg")
            do {
                try jpegData.write(to: filePath)
                let realm = try! Realm()
                try realm.write {
                    self.profileImageFileURL = filePath.absoluteString
                }
            } catch let error {
                print(error)
            }
        }
       
    }
    
    func loadImageFromDisc() -> UIImage? {
        
        var image: UIImage? = nil
        let docsDir = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(docsDir, userDomainMask, true)
        if let firstPath = paths.first {
            let imageURL = URL(fileURLWithPath: firstPath).appendingPathComponent(self.firstName + self.lastName + ".jpeg")
            let loadedImage = UIImage(contentsOfFile: imageURL.path)
            image = loadedImage
        }
        return image
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}











