//
//  WebViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 21/06/23.
//
import UIKit
import WebKit
class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var headerView: UIView!
    
    var webViewURL: String = ""
    var jsCode = ""
    var isOnMeta: Bool = Bool()
    var webViewTitle: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: webViewTitle)
        
        if isOnMeta {
            let htmlCode =  """
<script src="https://platform.onmeta.in/onmeta-sdk.js"></script> <meta name="viewport" content="width=device-width, initial-scale=1">
        <div id="widget"></div>
"""
            if let webView = webView { // Replace 'webViewOutlet' with your UIWebView outlet
                webView.loadHTMLString(htmlCode, baseURL: nil)
            }
            self.jsCode = webViewURL
        } else {
            
            webView.load(webViewURL)
            
        }
    }
    
}
extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isOnMeta {
            webView.evaluateJavaScript(jsCode, completionHandler: nil)
        }
    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        if isOnMeta {
////            webView.evaluateJavaScript(jsCode, completionHandler: nil)
//
//            webView.evaluateJavaScript(jsCode) { (result, error) in
//                       if let urlString = result as? String {
//                           print("urlString",urlString)
//                           // Check the URL and decide whether to change it
//                           if urlString.contains("example.com") {
//                               // Change the URL
//                               if let newURL = URL(string: "https://platform.onmeta.in/kyc") {
//                                   let request = URLRequest(url: newURL)
//                                   webView.load(request)
//                               }
//                           }
//                       }
//                   }
//               }
//        }
    
    
    
//    // Handle navigation events
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//            // Check if the navigation action is a user click (e.g., a link click)
//            if navigationAction.navigationType == .linkActivated {
//
//                // Construct a JavaScript string to change the URL
//                let newURL = "https://platform.onmeta.in/kyc" // Replace with the desired URL
//
//               let javascript = "window.location.href = '\(newURL)';"
//               // let javascript = jsCode
//
//                // Evaluate the JavaScript to change the URL
//                webView.evaluateJavaScript(javascript) { (result, error) in
//                    if let error = error {
//                        print("Error evaluating JavaScript: \(error)")
//                        decisionHandler(.cancel)
//                    } else {
//                        decisionHandler(.allow)
//                    }
//                }
//            } else {
//                // For other types of navigation, allow it
//                decisionHandler(.allow)
//            }
//        }
}
