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
import Web3Wallet
import Web3
import Combine
class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var headerView: UIView!
    
    var webViewURL: String = ""
    var jsCode = ""
    var isOnMeta: Bool = Bool()
    var webViewTitle: String = String()
    var isFrom = ""
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
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        if let url = navigationAction.request.url {
//            print(url)
//            print(url.host)
//        }
////           if navigationAction.navigationType == .linkActivated {
////               // Open links in current WKWebView
////               webView.load(navigationAction.request)
////               decisionHandler(.cancel)
////           } else {
////               decisionHandler(.allow)
////           }
//        decisionHandler(.allow)
//       }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            print(url.path)
            // Check if the URL contains the wallet connect button click event
            if url.absoluteString.contains("useWalletConnect=true") {
                // Handle the click event here
                print("Wallet Connect button clicked")
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
    
    
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let url = navigationAction.request.url, url.scheme == "wc" {
//            print("[WALLET] Pairing to: \(url)")
//            guard let uri = WalletConnectURI(string: url.absoluteString) else { return decisionHandler(.cancel)  }
//            Task {
//                do {
//                    try await Web3Wallet.instance.pair(uri: uri)
//
//                } catch {
//
//                    print("[DAPP] Pairing connect error: \(error)")
//                }
//
//        }
//            // Handle the deep link URL here
//            // You can also decide whether to continue loading the request or not
//
//        }
//
//        decisionHandler(.allow)
//    }
    /// pair to client
    func pairClient(uri: String) {
        print("[WALLET] Pairing to: \(uri)")
        guard let uri = WalletConnectURI(string: uri) else {
            return
        }
        Task {
            do {
                try await Web3Wallet.instance.pair(uri: uri)
                
            } catch {
               
                print("[DAPP] Pairing connect error: \(error)")
            }
        }
    }

    
//    // Intercept URL requests to handle deep linking
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            guard let url = navigationAction.request.url else {
//                decisionHandler(.cancel)
//                return
//            }
//
//            if url.scheme == "plutope://wc?" {
//                handleDeepLink(url: url)
//                decisionHandler(.cancel)
//                return
//            }
//
//            decisionHandler(.allow)
//        }
//    
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        print("00000")
//    }
//    // Handle deep linking based on the URL
//        func handleDeepLink(url: URL) {
//            // Extract any parameters from the URL if needed
////            let parameters = url.queryParameters
//
//            // Handle the deep link logic here
//            print("Deep link detected: \(url.absoluteString)")
//          //  print("Parameters: \(parameters)")
//        }
//   
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
