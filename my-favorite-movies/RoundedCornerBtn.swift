//
//  RoundedCornerBtn.swift
//  my-favorite-movies
//
//  Created by Amadeu Andrade on 28/05/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit

class RoundedCornerBtn: UIButton {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }

    func setButtonDisabled() {
        self.enabled = false
        self.alpha = 0.5
    }
    
    func addBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 253.0/255.0, green: 213.0/255.0, blue: 107.0/255.0, alpha: 1.0).CGColor
    }
    
}