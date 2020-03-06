//
//  Extensions.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/24/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit

struct Sorted {
    var key: String
    var ascending: Bool = true
}

extension UIViewController {
    public func add(asChildViewController viewController: UIViewController, to containerView: UIView) {
        // add child view controller
        addChild(viewController)
        
        // add child view as subView
        containerView.addSubview(viewController.view)
        
        // configure child view
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // notify child view controller
        viewController.willMove(toParent: self)
    }
    
    public func remove(childViewController viewController: UIViewController?) {
        // notify child view controller
        viewController?.willMove(toParent: nil)
        
        // remove view from superview
        viewController?.view.removeFromSuperview()
        
        // notify child view controller
        viewController?.removeFromParent()
    }
}

extension UIColor {
    
    // Affiliation Colors
    static let jediColor = UIColor(red: 0.635, green: 0.451, blue: 0.200, alpha: 1.00)
    static let resistanceColor = UIColor(red: 0.239, green: 0.525, blue: 0.886, alpha: 1.00)
    static let firstOrderColor = UIColor(red: 0.647, green: 0.137, blue: 0.075, alpha: 1.00)
    static let sithColor = UIColor(red: 0.133, green: 0.122, blue: 0.125, alpha: 1.00)
    
    // Supporting Colors
    static let jet = UIColor(red: 0.200, green: 0.196, blue: 0.196, alpha: 1.00)
    static let navColor = UIColor(red: 0.780, green: 0.737, blue: 0.663, alpha: 1.00)
//    static let navTintColor = UIColor(red: 0.388, green: 0.765, blue: 0.922, alpha: 1.00)
    static let navTintColor = UIColor(red: 0.176, green: 0.188, blue: 0.278, alpha: 1.00)
}
