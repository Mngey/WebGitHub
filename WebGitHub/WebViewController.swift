//
//  WebViewController.swift
//  WebGitHub
//
//  Created by a.a.mitrofanova on 11/09/2020.
//  Copyright © 2020 mngey. All rights reserved.
//

import UIKit

import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    var passedValue = ""
    
    override func loadView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       let url = URL(string: passedValue)
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
    }
    


}
