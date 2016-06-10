//
//  SearchVC.swift
//  my-favorite-movies
//
//  Created by Amadeu Andrade on 26/05/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import CoreData

class SearchVC: UIViewController {

    @IBOutlet weak var selectAnOptionLbl: UILabel!
    @IBOutlet weak var magnifierImg: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var imdbIDField: UITextField!
    @IBOutlet weak var searchBtn: RoundedCornerBtn!
    
    var movie: Movie!
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBtn.setButtonDisabled()
        
        let entity = NSEntityDescription.entityForName("Movie", inManagedObjectContext: context)!
        movie = Movie(entity: entity, insertIntoManagedObjectContext: context)
    }

    @IBAction func onSearchByPressed(sender: UIButton) {
        searchBtn.enabled = true
        searchBtn.alpha = 1.0
        selectAnOptionLbl.hidden = true
        magnifierImg.alpha = 0.25
        if sender.tag == 0 {
            titleField.hidden = false
            yearField.hidden = false
            imdbIDField.text = ""
            imdbIDField.hidden = true
        } else if sender.tag == 1 {
            titleField.text = ""
            yearField.text = ""
            titleField.hidden = true
            yearField.hidden = true
            imdbIDField.hidden = false
        }
    }
    
    @IBAction func onSearchPressed(sender: UIButton) {
        var url: NSURL?
        
        if imdbIDField.text != "" {
            url = NSURL(string: "http://www.omdbapi.com/?i=\(imdbIDField.text!)&plot=short&r=json")
        } else if titleField.text != "" && yearField.text != "" {
            let stringToUrl = titleField.text!.stringByReplacingOccurrencesOfString(" ", withString: "+")
            url = NSURL(string: "http://www.omdbapi.com/?t=\(stringToUrl)&y=\(yearField.text!)&plot=short&r=json")
        } else if titleField.text != "" {
            let stringToUrl = titleField.text!.stringByReplacingOccurrencesOfString(" ", withString: "+")
            url = NSURL(string: "http://www.omdbapi.com/?t=\(stringToUrl)&plot=short&r=json")
        }
        
        if url != nil {
            makeMovieInfoRequest(url!)
        } else {
            UtilAlerts().showAlert(self, title: "Warning", message: UtilAlerts.applicationAlerts.MissingInformation)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMovie" {
            if let viewToBeCalled = segue.destinationViewController as? ShowMovieVC {
                viewToBeCalled.movieToShow = sender as! Movie
            }
        }
    }
    
}
