//
//  Web3BrowserViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 12/03/24.
//

import UIKit
import WebKit
import Foundation
import JavaScriptCore
import Combine
import ReownWalletKit
import Commons
import WalletConnectSign
import Web3
class Web3BrowserViewController: UIViewController , WKUIDelegate , WKNavigationDelegate {
    
    @IBOutlet  var webView: WKWebView!
    @IBOutlet weak var headerView: UIView!
    var webViewURL: String = ""
    var jsCode = ""
    var isOnMeta: Bool = Bool()
    var webViewTitle: String = String()
    var isFrom = ""
    var coinDetail: Token?
    lazy var webView1: WKWebView = {
        let webView = WKWebView(
            frame: .zero,
            configuration:config)
        webView.allowsBackForwardNavigationGestures = true
        webView.backgroundColor = .clear
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.bounces = true
        webView.scrollView.isScrollEnabled = true
        webView.isUserInteractionEnabled = true
        webView.scrollView.bounces = true
//        webView.allowsLinkPreview = true
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: webViewTitle)
        webView1.isUserInteractionEnabled = true
        // Replace the existing webView with the newWebView in the view hierarchy
        webView.removeFromSuperview()
        webView = webView1
        webView.allowsBackForwardNavigationGestures = true
        webView.backgroundColor = .clear
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.bounces = true
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        webView.isUserInteractionEnabled = true 
//        webView.allowsLinkPreview = true
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.heightAnchor.constraint(greaterThanOrEqualToConstant: 709)
        ])
        injectUserAgent()
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36"
        webView.load(webViewURL)
        
    }
    lazy var config: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration.make(forType: .dappBrowser(coinDetail?.chain?.rpcURL ?? "", coinDetail?.chain?.chainId ?? ""), address: WalletData.shared.getPublicWalletAddress(coinType: .ethereum) ?? "", messageHandler: ScriptMessageProxy(delegate: self))
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        return config
    }()
    private func injectUserAgent() {
        webView1.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
            guard let strongSelf = self, let currentUserAgent = result as? String else { return }
            strongSelf.webView1.customUserAgent = currentUserAgent
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
                decisionHandler(.allow) // Allow loading if URL cannot be opened in Safari
            
        } else {
            decisionHandler(.allow) // Allow the WebView to load the URL normally
        }
    }  
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        
////        if (navigationAction.navigationType == .linkActivated){
////               decisionHandler(.cancel)
////           } else {
////               decisionHandler(.allow)
////           }
//        if #available(iOS 16.0, *) {
//            if let host = navigationAction.request.url?.host() {
//                print(navigationAction.request.url)
//                decisionHandler(.allow)
//            }
//            else {
//                decisionHandler(.allow)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
}
extension Web3BrowserViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("sdfdsf")
        let decoder = JSONDecoder()
        guard let body = message.body as? [String: AnyObject] else {
            return
            //return nil
        }
        print(body)
        let name =  body["name"] as? String ?? ""
        if name == "sendTransaction" {
            let params = body["object"]
            DGProgressView.shared.showLoader(to:view)
            print(params)
            var toAddress = ""
            var from = ""
            var gas = ""
            var value : Int = 0
            var data = ""
            var trasHash : EthereumData? = nil
            let command = [params as? [String: Any]]
            
            if let jsonArray = command as? [[String: Any]] {
                for var item in jsonArray {
                    for (key, value) in item {
                        if let hexString = value as? String, key != "to" {
                            if let intValue = Int(hexString.replacingOccurrences(of: "0x", with: ""), radix: 16) {
                                item[key] = intValue
                            }
                        }
                    }
                    print(item)
                    toAddress = item["to"] as? String ?? ""
                    gas = item["gas"] as? String ?? "0"
                    from = item["from"] as? String ?? ""
                    value = item["value"] as? Int ?? 0
                    data = item["data"] as? String ?? ""
                }
            }
            let semaphore = DispatchSemaphore(value: 0)
            if(value == 0) {
                var coinDetailObj = self.coinDetail
                print("coinDetailObj", coinDetailObj)
                var trasHash : EthereumData? = nil
                DispatchQueue.main.async {
                    coinDetailObj?.callFunction.signAndSendTranscation(toAddress, gasLimit:   BigUInt(gas) ?? BigUInt(30000) , gasPrice: "", txValue: 0, rawData: data ,  completion: { status,transfererror,dataResult  in
                        if status {
                            
                            DispatchQueue.main.async {
                                print("success")
                                print(dataResult!.hex())
                                trasHash = dataResult
                                semaphore.signal()
                                DGProgressView.shared.hideLoader()
                                let callbackId : Int32  = body["id"] as? Int32 ?? 0
                                let transcationId :String = trasHash!.hex()
                                self.webView.evaluateJavaScript("executeCallback(\(callbackId), null, \"\(transcationId)\")")
                                
                            }
                        } else {
                            print("fail")
                            semaphore.signal()
                            DGProgressView.shared.hideLoader()
                        }
                    })
                }
                
            } else {
                let coinDetailObj = self.coinDetail
                print("coinDetailObj",coinDetailObj)
                DispatchQueue.main.async {
                    let txtVallue : Double = Double(UnitConverter.convertWeiToEther(value.description , 18) ?? "0" ) ?? 0.0
                    coinDetailObj?.callFunction.sendTokenOrCoin(toAddress, tokenAmount: txtVallue , completion: { status,transfererror,dataResult  in
                        if status {
                            
                            DispatchQueue.main.async {
                                print("success")
                                print(dataResult!.hex())
                                trasHash = dataResult
                                semaphore.signal()
                                DGProgressView.shared.hideLoader()
                                let callbackId : Int32  = body["id"] as? Int32 ?? 0
                                let transcationId :String = trasHash!.hex()
                                self.webView.evaluateJavaScript("executeCallback(\(callbackId), null, \"\(transcationId)\")")
                            }
                        } else {
                            print("fail")
                            semaphore.signal()
                            DGProgressView.shared.hideLoader()
                        }
                    })
                }
            }
            //  semaphore.wait()
        }
    }
}

