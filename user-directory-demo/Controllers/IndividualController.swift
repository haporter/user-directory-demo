//
//  UserController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/24/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import Foundation


fileprivate struct Results: Codable {   // This struct is only intended to help parse
    let individuals: [Individual]       //  the JSON returned from the API call //
}

class IndividualController {
    
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
                    completion(results.individuals)
                    IndividualController.individuals = results.individuals
                    print("I have this many individuals: \(results.individuals.count)")
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
