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
