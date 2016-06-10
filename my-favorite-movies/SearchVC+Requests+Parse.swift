//
//  SearchVC+Requests+Parse.swift
//  my-favorite-movies
//
//  Created by Amadeu Andrade on 03/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation
import UIKit

extension SearchVC {

    func makeMovieInfoRequest(url: NSURL) {
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, _, error in
            if let data = data {
                self.parseMovieInfoJSON(data)
            } else {
                print(error)
            }
        }
        task.resume()
    }
    
    func makeMovieVideoRequest(imdbid: String) {
        let url = NSURL(string: "http://api.themoviedb.org/3/movie/\(imdbid)/videos?api_key=e55425032d3d0f371fc776f302e7c09b")!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let data = data {
                self.parseVideoInfoJSON(data)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.performSegueWithIdentifier("showMovie", sender: self.movie)
                }
                
            } else {
                print(error)
            }
        }
        task.resume()
    }
    
    func parseVideoInfoJSON(data: NSData) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let jsonResults = json["results"] as? [[String: AnyObject]] {
                for result in jsonResults {
                    if let code = result["key"] as? String {
                        self.movie.videoPath = "https://www.youtube.com/watch?v=\(code)"
                        break
                    }
                }
            }
        } catch {
            print("error serializing JSON")
        }
    }
    
    func parseMovieInfoJSON(data: NSData) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let responde = json["Response"] as? String where responde == "False" {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    UtilAlerts().showAlert(self, title: "Warning", message: UtilAlerts.applicationAlerts.WrongInformation)
                }
            } else if let actors = json["Actors"] as? String,
                let awards = json["Awards"] as? String,
                let genre = json["Genre"] as? String,
                let image = json["Poster"] as? String,
                let imdbID = json["imdbID"] as? String,
                let imdbRating = json["imdbRating"] as? String,
                let plot = json["Plot"] as? String,
                let releaseDate = json["Released"] as? String,
                let runtime = json["Runtime"] as? String,
                let title = json["Title"] as? String,
                let year = json["Year"] as? String {
                self.movie.actors = actors
                self.movie.awards = awards
                self.movie.genre = genre
                if let url = NSURL(string: "\(image)") {
                    if let data = NSData(contentsOfURL: url) {
                        self.movie.image = data
                    } else {
                        self.movie.image = UIImagePNGRepresentation(UIImage(named: "nomovie")!)
                    }
                }
                self.movie.imdbID = "http://www.imdb.com/title/\(imdbID)/"
                self.movie.imdbRating = imdbRating
                self.movie.plot = plot
                self.movie.releaseDate = releaseDate
                self.movie.runtime = runtime
                self.movie.title = title
                self.movie.year = year
                
                makeMovieVideoRequest(imdbID)
                
            }
        } catch {
            print("error serializing JSON")
        }
    }
    
}