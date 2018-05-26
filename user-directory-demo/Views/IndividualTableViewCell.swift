//
//  IndividualTableViewCell.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/25/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit

class IndividualTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affiliationImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarView.layer.cornerRadius = 8
        avatarView.layer.borderWidth = 3
        avatarView.layer.borderColor = UIColor.white.cgColor
    }
    
    func configureCell(forIndividual individual: Individual) {
        nameLabel.text = "\(individual.firstName) \(individual.lastName)"
        setColorAndSymbol(forAffiliation: individual.affiliation)
        if let image = individual.profileImage {
            avatarImageView.image = image
        }
    }
    
    fileprivate func setColorAndSymbol(forAffiliation affiliation: Individual.Affiliation) {
        var affiliationColor: UIColor
        var affiliationImage: UIImage
        switch affiliation {
        case .jedi:
            affiliationColor = UIColor.jediColor
            affiliationImage = #imageLiteral(resourceName: "Jedi_symbol")
        case .resistance:
            affiliationColor = UIColor.resistanceColor
            affiliationImage = #imageLiteral(resourceName: "Rebel_Alliance_logo.svg")
        case .firstOrder:
            affiliationColor = UIColor.firstOrderColor
            affiliationImage = #imageLiteral(resourceName: "First_Order_logo")
        case .sith:
            affiliationColor = UIColor.sithColor
            affiliationImage = #imageLiteral(resourceName: "sith_logo")
        case .joeShmo:
            affiliationColor = .white
            affiliationImage = #imageLiteral(resourceName: "joe")
            
        }
        colorView.backgroundColor = affiliationColor
        affiliationImageView.image = affiliationImage
    }
}
