//
//  UserController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/24/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


fileprivate struct Results: Codable {   // This struct is only intended to help parse
    let individuals: [Individual]       //  the JSON returned from the API call //
}

class IndividualController {
    
    static let operationQueue = OperationQueue()
    static var operationsCache = [String: Operation]()
    
    static var individuals: [Individual] = []
    
    private static let individualsDirectoryURLString = "https://edge.ldscdn.org/mobile/interview/directory"
    
    static func getIndividuals( completion: @escaping (_ individuals: [Individual])-> Void) {
        NetworkController.fetchData(fromUrl: individualsDirectoryURLString) { (data, error) in
            if let _ = error {
                completion([])
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(Results.self, from: data)
                    
                    let realm = try! Realm()
                    
                    try realm.write {
                        realm.deleteAll()
                    }
                    
                    for individual in results.individuals {
                        try realm.write {
                            realm.add(individual)
                        }
                    }
                    
                    completion(results.individuals)     // Comment this line
//                    completion([])                    // and uncomment this line to test empty state
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
