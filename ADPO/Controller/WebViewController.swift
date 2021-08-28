//
//  WebViewController.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 06.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate{
    
    @IBOutlet weak var webView: WKWebView!
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self //Setting delegate
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { //This executes when webview loads evetything
        hideActivityIndicator()
    }
    
    //MARK: - Activity Indicator Stuff
    
    func showActivityIndicator (shouldNotEnableUserInteraction : Bool = true) {
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        shouldNotEnableUserInteraction ? UIApplication.shared.beginIgnoringInteractionEvents() : nil
        
    }
    
    func hideActivityIndicator(){
        
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        
    }
    
    
    
}
