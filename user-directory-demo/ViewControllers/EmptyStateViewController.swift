//
//  EmptyStateViewController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/23/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit

protocol EmptyStateDelegate {
    func didSelectTryAgain()
}

class EmptyStateViewController: UIViewController {
    
    var delegate: EmptyStateDelegate?
    
    @IBAction func tryAgainButtonTapped(_ sender: UIButton) {
        delegate?.didSelectTryAgain()
    }
    
}
