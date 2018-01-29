//
//  MixCloudProfileViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 29/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import WebKit

class MixCloudProfileViewController: UIViewController {

    // Properties
    var profileURL: URL?
    
    
    // Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    //@IBOutlet weak var foreground: UIView!
    @IBOutlet weak var dismissViewButton: UIButton!
    @IBAction func dismissMixcloudView(_ sender: UIButton) {
        pressedDismissView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setDismissButton()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = Colors.logoRed
        loadUrl()

    }

    private func loadUrl() {
        guard let _profileURL = profileURL else { return }
        spinner.startAnimating()
        webView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let request = URLRequest(url: _profileURL)
        webView.load(request)
    }
    
    private func pressedDismissView() {
        print("Pressed Dismiss view")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setDismissButton() {
        guard let iconClose = FAType.FATimesCircle.text else { return }
        let attrClose = fontAwesomeAttributedString(forString: iconClose, withColor: Colors.logoRed, andFontSize: 20)
        
        let attributeOne = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 20.0)! ]
        let close = NSAttributedString(string: " Close", attributes: attributeOne)
        let combinedAttributedText = NSMutableAttributedString()
        combinedAttributedText.append(attrClose)
        combinedAttributedText.append(color(attributedString: close, color: Colors.logoRed))
        dismissViewButton.setAttributedTitle(combinedAttributedText, for: .normal)
    }
    
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}



extension MixCloudProfileViewController: WKNavigationDelegate
{
    
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
