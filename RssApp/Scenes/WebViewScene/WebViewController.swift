//
//  WebViewController.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 24.12.2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    // MARK: - PROPERTIES
    private var webView: WKWebView!
    var url: URL?
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
