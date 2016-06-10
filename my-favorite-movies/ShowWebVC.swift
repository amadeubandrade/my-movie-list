//
//  ShowWebVC.swift
//  my-favorite-movies
//
//  Created by Amadeu Andrade on 01/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import WebKit

class ShowWebVC: UIViewController {

    @IBOutlet weak var container: UIView!
    
    var webView: WKWebView!
    var urlFromShowVC: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        container.addSubview(webView)
    }

    override func viewDidAppear(animated: Bool) {
        let frame = CGRectMake(0, 0, container.bounds.width, container.bounds.height)
        webView.frame = frame
        loadRequest(urlFromShowVC)
    }

    func loadRequest(urlString: String) {
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    

}
