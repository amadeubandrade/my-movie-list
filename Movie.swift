//
//  Movie.swift
//  my-favorite-movies
//
//  Created by Amadeu Andrade on 02/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Movie: NSManagedObject {

    func setMovieImage(img: UIImage?) {
        if let movieImg = img {
            let data = UIImagePNGRepresentation(movieImg)
            self.image = data
        } else {
            let data = UIImagePNGRepresentation(UIImage(named: "nomovie")!)
            self.image = data
        }
    }
    
    func getMovieImage() -> UIImage {
        if let imgData = self.image {
            let img = UIImage(data: imgData)!
            return img
        } else {
            let img = UIImage(named: "nomovie")!
            return img
        }
    }
    
}
