//
//  ImageLoadOperation.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/25/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import Foundation

class ImageLoadOperation: Operation {
    var individual: Individual
    var loadingHandler: ((Individual) -> ())?
    
    init(_ individual: Individual) {
        self.individual = individual
    }
    
    override func main() {
        if isCancelled { return }
        
        individual.getProfileImage()
        
        if let loadingHandler = loadingHandler {
            DispatchQueue.main.async {
                loadingHandler(self.individual)
            }
        }
    }
}
