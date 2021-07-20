//
//  webViewController.swift
//  TMREIS
//
//  Created by deep chandan on 30/06/21.
//

import UIKit
import WebKit
class WebViewController : UIViewController , WKNavigationDelegate
{
    var webView : WKWebView = {
        let wk = WKWebView()
        return wk
    }()
    var urlStr : String?    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        if let urlS = urlStr{
            if let url = URL(string: urlS)
            {
                webView.navigationDelegate = self
                webView.load(URLRequest(url: url))
            }
        }
        
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFInish")
    }
    
    
    
}
