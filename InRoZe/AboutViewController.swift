//
//  AboutViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 27/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {

    // Properties
    var aboutURL: URL?
    
    
    // Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var foreground: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = Colors.logoRed
        loadUrl()
        
    }


    private func loadUrl() {
        guard let _aboutURL = aboutURL else { return }
        spinner.startAnimating()
        webView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let request = URLRequest(url: _aboutURL)
        print("Load: [\(Date())]")
        webView.load(request)
    }


}

extension AboutViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("Loading Done: [\(Date())]")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //print("didStartProvisionalNavigation: [\(Date())]")
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //print("didCommit: [\(Date())]")
        spinner.stopAnimating()
        webView.backgroundColor = .white
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        webView.backgroundColor = .white
        print("Loading ERROR: [\(Date())]")
    }
}








