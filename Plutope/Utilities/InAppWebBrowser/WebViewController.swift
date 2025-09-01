//
//  WebViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 21/06/23.
//
import UIKit
import WebKit
import WalletConnectSign
import WalletConnectUtils
import ReownWalletKit
import Web3
import Combine
class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var headerView: UIView!
    weak var delegate : GotoBuyDashBoardDelegate?
    var webViewURL: String = ""
    var jsCode = ""
    var isOnMeta: Bool = Bool()
    var webViewTitle: String = String()
    var isFrom = ""
    var successUrl = ""
    var failerUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if isFrom == "coinDetail" {
            let configuration = WKWebViewConfiguration()
              configuration.preferences.javaScriptEnabled = true
               configuration.urlSchemeHandler(forURLScheme: "plutope")
        }
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
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            print(url.path)
            // Check if the URL contains the wallet connect button click event
        
        if isFrom == "buyCrypto" {
            if url.absoluteURL.description == self.successUrl {
                self.dismiss(animated: false) {
                    self.delegate?.gotoBuyDashBoard(response: "")
                }
            } else if url.absoluteURL.description == self.failerUrl {
                self.dismiss(animated: false) {
                    self.delegate?.gotoBuyDashBoard(response: "")
                }
            }
        }
            decisionHandler(.allow)
        }
       func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
           if let url = webView.url {
               print("Current URL: \(url)")
               
           }
       }
       
       func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
           print("Failed to load URL: \(error)")
       }
}
