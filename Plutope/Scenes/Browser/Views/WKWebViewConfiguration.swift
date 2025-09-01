// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import WebKit
import JavaScriptCore
public protocol WithInjectableRpcUrl {
    var web3InjectedRpcURL: URL { get }
    var chainID: Int { get}
}

public enum WebViewType {
    case dappBrowser(String,String)
    case tokenScriptRenderer(String,String)
}

public enum Browser {
    public static let locationChangedEventName = "locationChanged"
}
public enum SetProperties {
    public static let setActionProps = "setActionProps"

    public typealias Properties = [String: Any]

    case action(id: Int, changedProperties: Properties)

    public static func fromMessage(_ message: WKScriptMessage) -> SetProperties? {
        guard message.name == SetProperties.setActionProps else { return nil }
        guard let body = message.body as? [String: AnyObject] else { return nil }
        guard let changedProperties = body["object"] as? SetProperties.Properties else { return nil }
        guard let id = body["id"] as? Int else { return nil }
        return .action(id: id, changedProperties: changedProperties)
    }
}
extension WKWebViewConfiguration {
    public static func make(forType type: WebViewType, address: String, messageHandler: WKScriptMessageHandler) -> WKWebViewConfiguration {
        let webViewConfig = WKWebViewConfiguration()
        var js = ""

        switch type {
        case .dappBrowser(let rpcUrl,let chainID):
            if let filepath = Bundle.main.path(forResource: "PlutopeWallet", ofType: "js") {
                do {
                    js += try String(contentsOfFile: filepath)
                } catch { }
            }
            js += Functional.javaScriptForDappBrowser(rpcURl: rpcUrl, chainID: chainID, address: WalletData.shared.myWallet?.address ?? "")
            
        case .tokenScriptRenderer(let rpcUrl,let chainID):
            js += Functional.javaScriptForTokenScriptRenderer(rpcURL: rpcUrl, chainID: chainID, address: WalletData.shared.myWallet?.address ?? "")
            js += """
                  \n
                  web3.tokens = {
                      data: {
                          currentInstance: {
                          },
                          token: {
                          },
                          card: {
                          },
                      },
                      dataChanged: (old, updated, tokenCardId) => {
                        console.log(\"web3.tokens.data changed. You should assign a function to `web3.tokens.dataChanged` to monitor for changes like this:\\n    `web3.tokens.dataChanged = (old, updated, tokenCardId) => { //do something }`\")
                      }
                  }
                  """
        }
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        webViewConfig.userContentController.addUserScript(userScript)

        switch type {
        case .dappBrowser:
            break
        case .tokenScriptRenderer:
            // TODO: enable content blocking rules to support whitelisting
            webViewConfig.setURLSchemeHandler(webViewConfig, forURLScheme: "tokenscript-resource")
        }

        HackToAllowUsingSafaryExtensionCodeInDappBrowser.injectJs(to: webViewConfig)
        webViewConfig.userContentController.add(messageHandler, name: Method.sendTransaction.rawValue)
        webViewConfig.userContentController.add(messageHandler, name: Method.signTransaction.rawValue)
        webViewConfig.userContentController.add(messageHandler, name: Method.signPersonalMessage.rawValue)
        webViewConfig.userContentController.add(messageHandler, name: Method.signMessage.rawValue)
        webViewConfig.userContentController.add(messageHandler, name: "eth_requestAccounts")
        webViewConfig.userContentController.add(messageHandler, name: Method.ethCall.rawValue)
        webViewConfig.userContentController.add(messageHandler, name: AddCustomChainCommand.Method.walletAddEthereumChain.rawValue)
//        webViewConfig.userContentController.add(messageHandler, name: SwitchChainCommand.Method.walletSwitchEthereumChain.rawValue)
        webViewConfig.userContentController.add(messageHandler, name: Browser.locationChangedEventName)
        // TODO: extract like `Method.signTypedMessage.rawValue` when we have more than 1
        webViewConfig.userContentController.add(messageHandler, name: SetProperties.setActionProps)
        return webViewConfig
    }
}

public enum Method: String, Decodable {
    case sendTransaction
    case signTransaction
    case signPersonalMessage
    case signMessage
    case signTypedMessage
    case ethCall
    case unknown

    public init(string: String) {
        self = Method(rawValue: string) ?? .unknown
    }
}
extension WKWebViewConfiguration {
    enum Functional {}
}

fileprivate extension WKWebViewConfiguration.Functional {
// swiftlint:disable function_body_length
    static func javaScriptForDappBrowser(rpcURl: String,chainID: String, address: String) -> String {
        return """
                      //Space is needed here because it is sometimes cut off by websites.

                      //The check is actually not needed, what is needed is the scoping of the variables in `else`
                      if (window.isPlutopeWalletInjected) {
                      } else {
                          window.isPlutopeWalletInjected = true

                          const walletAddress = "\(address)"
                          const addressHex = "\(address)"
                          const rpcURL = "\(rpcURl)"
                          const chainID = "\(chainID)"
                          function executeCallback (id, error, value) {
                              PlutopeWallet.executeCallback(id, error, value)
                          }

                          PlutopeWallet.init(rpcURL, {
                              getAccounts: function (cb) { cb(null, [addressHex]) },
                              processTransaction: function (tx, cb){
                                  console.log('signing a transaction', tx)
                                  const { id = 8888 } = tx
                                  PlutopeWallet.addCallback(id, cb)
                                  webkit.messageHandlers.sendTransaction.postMessage({"name": "sendTransaction", "object":     tx, id: id})
                              },
                              signMessage: function (msgParams, cb) {
                                  const { data } = msgParams
                                  const { id = 8888 } = msgParams
                                  console.log("signing a message", msgParams)
                                  PlutopeWallet.addCallback(id, cb)
                                  webkit.messageHandlers.signMessage.postMessage({"name": "signMessage", "object": { data }, id:    id} )
                              },
                              signPersonalMessage: function (msgParams, cb) {
                                  const { data } = msgParams
                                  const { id = 8888 } = msgParams
                                  console.log("signing a personal message", msgParams)
                                  PlutopeWallet.addCallback(id, cb)
                                  webkit.messageHandlers.signPersonalMessage.postMessage({"name": "signPersonalMessage", "object":  { data }, id: id})
                              },
                              signTypedMessage: function (msgParams, cb) {
                                  const { data } = msgParams
                                  const { id = 8888 } = msgParams
                                  console.log("signing a typed message", msgParams)
                                  PlutopeWallet.addCallback(id, cb)
                                  webkit.messageHandlers.signTypedMessage.postMessage({"name": "signTypedMessage", "object":     { data }, id: id})
                              },
                              ethCall: function (msgParams, cb) {
                                  const data = msgParams
                                  const { id = Math.floor((Math.random() * 100000) + 1) } = msgParams
                                  console.log("eth_call", msgParams)
                                  PlutopeWallet.addCallback(id, cb)
                                  webkit.messageHandlers.ethCall.postMessage({"name": "ethCall", "object": data, id: id})
                              },
                              walletAddEthereumChain: function (msgParams, cb) {
                                  const data = msgParams
                                  const { id = Math.floor((Math.random() * 100000) + 1) } = msgParams
                                  console.log("walletAddEthereumChain", msgParams)
                                  PlutopeWallet.addCallback(id, cb)
                                  webkit.messageHandlers.walletAddEthereumChain.postMessage({"name": "walletAddEthereumChain", "object": data, id: id})
                              },
                              walletSwitchEthereumChain: function (msgParams, cb) {
                                  const data = msgParams
                                  const { id = Math.floor((Math.random() * 100000) + 1) } = msgParams
                                  console.log("walletSwitchEthereumChain", msgParams)
                                  PlutopeWallet.addCallback(id, cb)
                                  webkit.messageHandlers.walletSwitchEthereumChain.postMessage({"name": "walletSwitchEthereumChain", "object": data, id: id})
                              },
                              enable: function() {
                    console.log("enabled ch");
                                 return new Promise(function(resolve, reject) {
                                     //send back the coinbase account as an array of one
                                     resolve([addressHex])
                                 })
                              }
                          }, {
                              address: addressHex,
                              networkVersion: "0x" + parseInt(chainID).toString(16) || null
                          })

                          web3.setProvider = function () {
                              console.debug('PlutopeWallet Wallet - overrode web3.setProvider')
                          }

                          web3.eth.defaultAccount = addressHex

                          web3.version.getNetwork = function(cb) {
                              cb(null, chainID)
                          }

                         web3.eth.getCoinbase = function(cb) {
                          return cb(null, addressHex)
                        }
                        window.ethereum = web3.currentProvider

                        // So we can detect when sites use History API to generate the page location. Especially common with React and similar frameworks
                        ;(function() {
                          var pushState = history.pushState;
                          var replaceState = history.replaceState;

                          history.pushState = function() {
                            pushState.apply(history, arguments);
                            window.dispatchEvent(new Event('locationchange'));
                          };

                          history.replaceState = function() {
                            replaceState.apply(history, arguments);
                            window.dispatchEvent(new Event('locationchange'));
                          };

                          window.addEventListener('popstate', function() {
                            window.dispatchEvent(new Event('locationchange'))
                          });
                        })();

                        window.addEventListener('locationchange', function(){
                          webkit.messageHandlers.\(Browser.locationChangedEventName).postMessage(window.location.href)
                        })
                    }
                    """
    }
// swiftlint:enable function_body_length

    static func javaScriptForTokenScriptRenderer(rpcURL: String, chainID: String, address: String) -> String {
        return """
               const walletAddress = "\(address)"
               const addressHex = "\(address)"
               const rpcURL = "\(rpcURL)"
               const chainID = "\(chainID)"

               window.web3CallBacks = {}
               window.tokenScriptCallBacks = {}

               function executeCallback (id, error, value) {
                   window.web3CallBacks[id](error, value)
                   delete window.web3CallBacks[id]
               }

               function executeTokenScriptCallback (id, error, value) {
                   let cb = window.tokenScriptCallBacks[id]
                   if (cb) {
                       window.tokenScriptCallBacks[id](error, value)
                       delete window.tokenScriptCallBacks[id]
                   } else {
                   }
               }

               web3 = {
                 personal: {
                   sign: function (msgParams, cb) {
                     const { data } = msgParams
                     const { id = 8888 } = msgParams
                     window.web3CallBacks[id] = cb
                     webkit.messageHandlers.signPersonalMessage.postMessage({"name": "signPersonalMessage", "object":  { data }, id: id})
                   }
                 },
                 action: {
                   setProps: function (object, cb) {
                     const id = 8888
                     window.tokenScriptCallBacks[id] = cb
                     webkit.messageHandlers.\(SetProperties.setActionProps).postMessage({"object":  object, id: id})
                   }
                 }
               }
               """
    }

    static func contentBlockingRulesJson() -> String {
        // TODO read from TokenScript, when it's designed and available
        let whiteListedUrls = [
            "https://unpkg.com/",
            "^tokenscript-resource://",
            "^http://stormbird.duckdns.org:8080/api/getChallenge$",
            "^http://stormbird.duckdns.org:8080/api/checkSignature"
        ]
        //Blocks everything, except the whitelisted URL patterns
        var json = """
                   [
                       {
                           "trigger": {
                               "url-filter": ".*"
                           },
                           "action": {
                               "type": "block"
                           }
                       }
                   """
        for each in whiteListedUrls {
            json += """
                    ,
                    {
                        "trigger": {
                            "url-filter": "\(each)"
                        },
                        "action": {
                            "type": "ignore-previous-rules"
                        }
                    }
                    """
        }
        json += "]"
        return json
    }
}

extension WKWebViewConfiguration: WKURLSchemeHandler {
    public func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        if urlSchemeTask.request.url?.path != nil {
            if let fileExtension = urlSchemeTask.request.url?.pathExtension, fileExtension == "otf", let nameWithoutExtension = urlSchemeTask.request.url?.deletingPathExtension().lastPathComponent {
                //TODO maybe good to fail with didFailWithError(error:)
                guard let url = Bundle.main.url(forResource: nameWithoutExtension, withExtension: fileExtension) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                //mimeType doesn't matter. Blocking is done based on how browser intends to use it
                let response = URLResponse(url: urlSchemeTask.request.url!, mimeType: "font/opentype", expectedContentLength: data.count, textEncodingName: nil)
                urlSchemeTask.didReceive(response)
                urlSchemeTask.didReceive(data)
                urlSchemeTask.didFinish()
                return
            }
        }
        //TODO maybe good to fail:
        //urlSchemeTask.didFailWithError(error:)
    }

    public func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        //Do nothing
    }
}

private struct HackToAllowUsingSafaryExtensionCodeInDappBrowser {
    private static func javaScriptForSafaryExtension() -> String {
        var js = String()

        if let filepath = Bundle.main.path(forResource: "config", ofType: "js"), let content = try? String(contentsOfFile: filepath) {
            js += content
        }
        if let filepath = Bundle.main.path(forResource: "helpers", ofType: "js"), let content = try? String(contentsOfFile: filepath) {
            js += content
        }
        return js
    }

    static func injectJs(to webViewConfig: WKWebViewConfiguration) {
        func encodeStringTo64(fromString: String) -> String? {
            let plainData = fromString.data(using: .utf8)
            return plainData?.base64EncodedString(options: [])
        }
        var js = javaScriptForSafaryExtension()
        js += """
                    const overridenElementsForPlutopeWalletExtension = new Map();
                    function runOnStart() {
                        function applyURLsOverriding(options, url) {
                            let elements = overridenElementsForPlutopeWalletExtension.get(url);
                            if (typeof elements != 'undefined') {
                                overridenElementsForPlutopeWalletExtension(elements)
                            }
            
                            overridenElementsForPlutopeWalletExtension.set(url, retrieveAllURLs(document, options));
                        }
            
                        const url = document.URL;
                        applyURLsOverriding(optionsByDefault, url);
                    }
            
                    if(document.readyState !== 'loading') {
                        runOnStart();
                    } else {
                        document.addEventListener('DOMContentLoaded', function() {
                            runOnStart()
                        });
                    }
            """

        let jsStyle =  """
                javascript:(function() {
                var parent = document.getElementsByTagName('body').item(0);
                var script = document.createElement('script');
                script.type = 'text/javascript';
                script.innerHTML = window.atob('\(encodeStringTo64(fromString: js)!)');
                parent.appendChild(script)})()
            """

        let userScript = WKUserScript(source: jsStyle, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webViewConfig.userContentController.addUserScript(userScript)
    }
}
