//
//  UserController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/24/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import Foundation

class IndividualController {
    
    private static let individualsDirectoryURLString = "https://edge.ldscdn.org/mobile/interview/directory"
    
    static func getIndividuals( completion: @escaping (_ individuals: [Individual])-> Void) {
        NetworkController.fetchData(fromUrl: individualsDirectoryURLString) { (data, error) in
            if let error = error {
                completion([])
            } else if let data = data {
                print(data)
            }
        }
    }
}
