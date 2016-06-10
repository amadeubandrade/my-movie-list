//
//  ViewController.swift
//  my-favorite-movies
//
//  Created by Amadeu Andrade on 25/05/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onSearchBtnPressed(sender: UIButton) {
        performSegueWithIdentifier("showSearchVC", sender: nil)
    }
    
    @IBAction func onFavoritesWatchlistBtnPressed(sender: UIButton) {
        performSegueWithIdentifier("showMoviesList", sender: sender.tag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMoviesList" {
            if let moviesList = segue.destinationViewController as? FavoriteWatchlistVC {
                if sender as? Int == 0 {
                    moviesList.watchlist = false
                } else if sender as? Int == 1 {
                    moviesList.watchlist = true
                }
            }
        }
    }
}

