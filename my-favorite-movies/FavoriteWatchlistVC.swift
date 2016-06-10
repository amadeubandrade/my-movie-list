//
//  FavoriteWatchlistVC.swift
//  my-favorite-movies
//
//  Created by Amadeu Andrade on 26/05/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import CoreData

class FavoriteWatchlistVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var watchlist: Bool!
    var favoritesArray = [Movie]()
    var watchlistArray = [Movie]()
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .Plain, target: self, action: #selector(FavoriteWatchlistVC.onAddBtnPressed))
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
    }
    
    func onAddBtnPressed() {
        performSegueWithIdentifier("showAddMovieVC", sender: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchAndSetResults()
        tableView.reloadData()
    }
    
    func fetchAndSetResults() {
        context.reset()
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        if watchlist == false {
            fetchRequest.predicate = NSPredicate(format: "favorites == %@", true)
        } else {
            fetchRequest.predicate = NSPredicate(format: "watchlist == %@", true)
        }
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            if watchlist == false {
                favoritesArray = results as! [Movie]
            } else {
                watchlistArray = results as! [Movie]
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if watchlist == false {
            return favoritesArray.count
        } else {
            return watchlistArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as? MovieCell {
            var movie: Movie!
            if watchlist == false {
                movie = favoritesArray[indexPath.row]
            } else {
                movie = watchlistArray[indexPath.row]
            }
            cell.configureCell(movie)
            return cell
        } else {
            return MovieCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if watchlist == false {
            performSegueWithIdentifier("showMovieVC", sender: favoritesArray[indexPath.row].objectID)
        } else {
            performSegueWithIdentifier("showMovieVC", sender: watchlistArray[indexPath.row].objectID)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if watchlist == false {
                context.deleteObject(favoritesArray[indexPath.row])
                favoritesArray.removeAtIndex(indexPath.row)
            } else {
                context.deleteObject(watchlistArray[indexPath.row])
                watchlistArray.removeAtIndex(indexPath.row)
                watchlistArray.removeAtIndex(indexPath.row)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            do {
                try context.save()
            } catch let err as NSError {
                print(err.debugDescription)
            }
            context.reset()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMovieVC" {
            if let viewToBeCalled = segue.destinationViewController as? ShowMovieVC {
                if let movieID = sender as? NSManagedObjectID {
                    let movie = context.objectWithID(movieID) as! Movie
                    viewToBeCalled.movieToShow = movie
                    viewToBeCalled.fromFavoritesWatchListVC = true
                }
            }
        }
    }

}
