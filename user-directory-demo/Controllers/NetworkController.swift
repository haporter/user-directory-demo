//
//  NetworkController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/24/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import Foundation

class NetworkController {
    
    static func fetchData(fromUrl url: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(data, error)
            } else if let data = data {
                completion(data, nil)
            }
        }
        dataTask.resume()
    }
}
