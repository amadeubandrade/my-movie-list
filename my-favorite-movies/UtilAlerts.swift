//
//  UtilAlerts.swift
//  my-favorite-movies
//
//  Created by Amadeu Andrade on 30/05/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit

class UtilAlerts {
    
    struct applicationAlerts {
        static let WrongInformation = "Movie not found in database. Please check if the information introduced is correct."
        static let MissingInformation = "All fields are mandatory and must be completed."
    }

    func showAlert(delegate: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
        delegate.presentViewController(alert, animated: true, completion: nil)
    }

}