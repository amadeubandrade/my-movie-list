//
//  ShowMovieVC.swift
//  my-favorite-movies
//
//  Created by Amadeu Andrade on 26/05/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import CoreData

class ShowMovieVC: UIViewController {
    
    @IBOutlet weak var movieCover: UIImageView!
    @IBOutlet weak var titleYear: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var awards: UILabel!
    @IBOutlet weak var plot: UILabel!
    @IBOutlet weak var youtube: RoundedCornerBtn!
    @IBOutlet weak var imdb: RoundedCornerBtn!
    @IBOutlet weak var addToFavoritesBtn: RoundedCornerBtn!
    @IBOutlet weak var addToWatchlistBtn: RoundedCornerBtn!
    
    var movieToShow: Movie!
    var fromFavoritesWatchListVC = false
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBarsOnTap = true
        updateMovieInfoToShow()
        
        if fromFavoritesWatchListVC {
            addToWatchlistBtn.setButtonDisabled()
            addToFavoritesBtn.setButtonDisabled()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.navigationBarHidden = false
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil && fromFavoritesWatchListVC == false {
            context.reset()
        }
    }
    
    @IBAction func onAddToPressed(sender: AnyObject) {
        if sender.tag == 0 {
            movieToShow.favorites = true
        } else {
            movieToShow.watchlist = true
        }
        context.insertObject(movieToShow)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.debugDescription)
        }
        context.reset()
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func onYoutubePressed(sender: AnyObject) {
        performSegueWithIdentifier("ShowWebVC", sender: movieToShow.videoPath)
    }
    
    @IBAction func onIMDbPressed(sender: AnyObject) {
        performSegueWithIdentifier("ShowWebVC", sender: movieToShow.imdbID)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowWebVC" {
            if let showWebVC = segue.destinationViewController as? ShowWebVC {
                showWebVC.urlFromShowVC = sender as! String
            }
        }
    }
    
    func updateMovieInfoToShow() {
        if let title = movieToShow.title, let year = movieToShow.year, let plotTxt = movieToShow.plot {
            movieCover.image = movieToShow.getMovieImage()
            titleYear.text = "\(title) (\(year))"
            plot.text = plotTxt
            if let imdbRating = movieToShow.imdbRating {
                rating.text = imdbRating
            } else {
                rating.text = "?"
            }
            if let releaseData = movieToShow.releaseDate {
                date.text = releaseData
            } else {
                date.text = "?"
            }
            if let movieGenre = movieToShow.genre {
                genre.text = movieGenre
            } else {
                genre.text = "?"
            }
            if let movieDuration = movieToShow.runtime {
                duration.text = movieDuration
            } else {
                duration.text = "?"
            }
            if let mainActors = movieToShow.actors {
                actors.text = mainActors
            } else {
                actors.text = "?"
            }
            if let movieAwards = movieToShow.awards {
                awards.text = movieAwards
            } else {
                awards.text = "?"
            }
            if movieToShow.videoPath == nil {
                youtube.setButtonDisabled()
            }
            if movieToShow.imdbID == nil {
                imdb.setButtonDisabled()
            }
            
        }
    }
    

}
