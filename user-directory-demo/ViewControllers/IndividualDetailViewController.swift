//
//  UserDetailViewController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/23/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit

class IndividualDetailViewController: UIViewController {
    
    @IBOutlet weak var affiliationColorView: UIView!
    @IBOutlet weak var profileMaskView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affiliationSymbolImageView: UIImageView!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var forceSensitiveLabel: UILabel!
    @IBOutlet weak var affiliationLabel: UILabel!
    
    private var individual: Individual!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileMaskView.layer.borderWidth = 3
        profileMaskView.layer.borderColor = UIColor.white.cgColor
        
        updateUI()
    }
    
    func configure(withIndividual individual: Individual) {
        self.individual = individual
    }
    
    private func updateUI() {
        setProfileImage()
        setText()
        setColorAndSymbol()
    }
    
    private func setProfileImage() {
        guard let image = individual.loadImageFromDisc() else { return }
        profileImageView.image = image
    }
    
    private func setText() {
        nameLabel.text = individual.firstName + " " + individual.lastName
        birthLabel.text = individual.birthdate
        forceSensitiveLabel.text = individual.forceSensitive ? "YES" : "NO"
        affiliationLabel.text = individual.affiliation.description
    }
    
    private func setColorAndSymbol() {
        var affiliationColor: UIColor
        var affiliationImage: UIImage
        switch individual.affiliation {
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
        affiliationColorView.backgroundColor = affiliationColor
        affiliationSymbolImageView.image = affiliationImage
    }
}
