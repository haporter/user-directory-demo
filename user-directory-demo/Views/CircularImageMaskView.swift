//
//  CircularImage.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/27/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit

class CircularImageMaskView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = self.bounds.size.width / 2
        
        self.layer.cornerRadius = radius
    }
}
