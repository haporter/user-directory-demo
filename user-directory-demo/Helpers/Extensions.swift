//
//  Extensions.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/24/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit

extension UIViewController {
    public func add(asChildViewController viewController: UIViewController, to containerView: UIView) {
        // add child view controller
        addChildViewController(viewController)
        
        // add child view as subView
        containerView.addSubview(viewController.view)
        
        // configure child view
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // notify child view controller
        viewController.willMove(toParentViewController: self)
    }
    
    public func remove(childViewController viewController: UIViewController?) {
        // notify child view controller
        viewController?.willMove(toParentViewController: nil)
        
        // remove view from superview
        viewController?.view.removeFromSuperview()
        
        // notify child view controller
        viewController?.removeFromParentViewController()
    }
}

extension UIColor {
    static let jediColor = UIColor(red: 0.635, green: 0.451, blue: 0.200, alpha: 1.00)
    static let resistanceColor = UIColor(red: 0.239, green: 0.525, blue: 0.886, alpha: 1.00)
    static let firstOrderColor = UIColor(red: 0.647, green: 0.137, blue: 0.075, alpha: 1.00)
    static let sithColor = UIColor(red: 0.133, green: 0.122, blue: 0.125, alpha: 1.00)
}
