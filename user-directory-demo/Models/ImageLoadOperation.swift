//
//  ImageLoadOperation.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/25/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ImageLoadOperation: Operation {
    var individualRef: ThreadSafeReference<Individual>
    var loadingHandler: ((ThreadSafeReference<Individual>) -> ())?
    
    init(_ individualRef: ThreadSafeReference<Individual>) {
        self.individualRef = individualRef
    }
    
    override func main() {
        if isCancelled { return }
        var primaryKey = ""
        
        autoreleasepool {
            let realm = try! Realm()
            guard let individual = realm.resolve(self.individualRef) else {
                fatalError("realm object no longer exits")
            }
            individual.getProfileImage()
            primaryKey = individual.id
        }
        
        if let loadingHandler = loadingHandler {
            DispatchQueue.main.async {
                autoreleasepool {
                    let realm = try! Realm()
                    guard let individual = realm.object(ofType: Individual.self, forPrimaryKey: primaryKey) else {
                        fatalError("can't get object from realm")
                    }
                    let individualRef = ThreadSafeReference(to: individual)
                    loadingHandler(individualRef)
                }
            }
        }
    }
}
