//
//  WebViewViewController.swift
//  ADPO
//
//  Created by Sam on 24.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var request : URLRequest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeRequest = request{
            webView.load(safeRequest)
        }
    }

    @IBAction func menuPressed(_ sender: UIButton) {
    }
}
