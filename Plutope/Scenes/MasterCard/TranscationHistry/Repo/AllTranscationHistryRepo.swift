//
//  AllTranscationHistryRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/06/24.
//

import Foundation
import DGNetworkingServices
enum NetworkError: Error {
    case authenticationError
    case invalidURL
    case invalidResponse
    case noData
}
class AllTranscationHistryRepo {
    func apiGetAllHistory(offset:Int,size:Int,completion: @escaping(Int,String,[AllTransactionHistryDataList]?) -> Void) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiRequestUrl = ServiceNameConstant.historyNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiRequestUrl)?offset=\(offset)&size=\(size)"
        
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: headers) { status, error, data in
            if status {
                guard let responseData = data, !responseData.isEmpty else {
                    
                    completion(0, "Empty response from server", nil)
                    return
                }
                if let jsonString = String(data: responseData, encoding: .utf8) {
                    
                }
                
                do {
                    // Decode JSON Array Response
                    let decodedArray = try JSONDecoder().decode([AllTransactionHistryDataList].self, from: responseData)
                    
                    if decodedArray.isEmpty {
                        completion(0, "", nil)
                    } else {
                        completion(1, "", decodedArray)  // Return all objects
                    }
                } catch {
                    completion(0, "Failed to parse response", nil)
                }
            } else {
                // Handle API errors
                if let errorMessage = error?.rawValue {
                    if errorMessage == "Access token expired" {
                        logoutApp()
                    } else if errorMessage == "it looks like your device is offline please make sure your internet connection is stable." {
                        completion(0, "it looks like your device is offline please make sure your internet connection is stable.", nil)
                    } else {
                        completion(0, errorMessage, nil)
                    }
                } else {
                    completion(0, "Unknown error occurred", nil)
                }
            }
        }
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            
//            switch result {
//                
//            case .success((_, let response)):
//                do {
//                    
//                    let decodeResult = try JSONDecoder().decode(AllTransactionHistryData.self, from: response)
//                    if decodeResult.status == 200 {
//                        completion(1,"",decodeResult.data?.finalResponse)
//                    } else if decodeResult.status  == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0,decodeResult.message ?? "" ,nil)
//                    }
//                    
//                } catch(let error) {
//                    
//                    print(error)
//                    completion(0,error.localizedDescription ,nil)
//                }
//            case .failure(let error):
//                
//                print(error)
//                //                completion(0,error.rawValue, nil)
//                let errValue = error.rawValue
//                if (errValue == "Access token expired") {
//                    logoutApp()
//                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
//                } else {
//                    completion(0,error.rawValue,nil)
//                }
//            }
//        }
    }
    
    func apiGetSingleWalletHistory(currencyFilter: String, completion: @escaping (Int, String, [SingleTransactionHistry]?) -> Void) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiRequestUrl = ServiceNameConstant.historyOperationsNew
        
        //        // Properly encode the currencyFilter array as a JSON string
        //        let currencyFilterData = try? JSONSerialization.data(withJSONObject: currencyFilter ?? [])
        //        guard let currencyFilterString = String(data: currencyFilterData!, encoding: .utf8) else {
        //            completion(0, "Failed to encode currency filter", nil)
        //            return
        //        }
        //
        //        // URL-encode the JSON string
        //        guard let encodedCurrencyFilter = currencyFilterString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        //            completion(0, "Failed to encode currency filter", nil)
        //            return
        //        }
        
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiRequestUrl)?currencyFilter=\(currencyFilter)&offset=0&size=50"
        //        v2/history/operations?currencyFilter=USDT&offset=0&size=50
        print("URL =", apiUrl)
        
        // Fetch auth token from UserDefaults
//        guard let authToken = UserDefaults.standard.value(forKey: loginApiToken) as? String else {
//            completion(0, "Authorization token not found", nil)
//            return
//        }
        
        //        let headers = ["auth": authToken]
        
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: headers) { status, error, data in
            if status {
                guard let responseData = data, !responseData.isEmpty else {
                    
                    completion(0, "Empty response from server", nil)
                    return
                }
                if let jsonString = String(data: responseData, encoding: .utf8) {
                    
                }
                
                do {
                    // Decode JSON Array Response
                    let decodedArray = try JSONDecoder().decode([SingleTransactionHistry].self, from: responseData)
                    
                    if decodedArray.isEmpty {
                        completion(0, "", nil)
                    } else {
                        completion(1, "", decodedArray)  // Return all objects
                    }
                } catch {
                    completion(0, "Failed to parse response", nil)
                }
            } else {
                // Handle API errors
                if let errorMessage = error?.rawValue {
                    if errorMessage == "Access token expired" {
                        logoutApp()
                    } else if errorMessage == "it looks like your device is offline please make sure your internet connection is stable." {
                        completion(0, "it looks like your device is offline please make sure your internet connection is stable.", nil)
                    } else {
                        completion(0, errorMessage, nil)
                    }
                } else {
                    completion(0, "Unknown error occurred", nil)
                }
            }
        }
    }
    
    /// live
    func fetchTransactions(offset: Int, size: Int, completion: @escaping (Result<[AllTransactionHistryDataListNewElement], Error>) -> Void) {
        // Construct the API URL
        let baseURL = ServiceNameConstant.BaseUrl.baseUrlNew
        let appVersion = ServiceNameConstant.appVersion
        let historyEndpoint = ServiceNameConstant.historyNew
        let apiUrl = "\(baseURL)\(appVersion)\(historyEndpoint)?offset=\(offset)&size=\(size)"
        
        // Get auth token from UserDefaults (replace with your actual token retrieval logic)
        guard let authToken = UserDefaults.standard.value(forKey: loginApiToken) as? String else {
            completion(.failure(NetworkError.authenticationError))
            return
        }
        
        // Create URL components and session
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check HTTP response status codes
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            // Ensure data is not nil
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Decode JSON response into array of AllTransactionHistryDataListNewElement
                let decodedData = try JSONDecoder().decode([AllTransactionHistryDataListNewElement].self, from: data)
                
                // Process the decoded data (e.g., map and update transactions)
                let updatedTransactions = decodedData.map { transaction -> AllTransactionHistryDataListNewElement in
                    var updatedTransaction = transaction
                    // updatedTransaction.type = self.determineOperationType(for: transaction)
                    //  updatedTransaction.title = self.determineTitle(for: transaction)
                    return updatedTransaction
                }
                
                completion(.success(updatedTransactions))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func determineOperationType(for transaction: AllTransactionHistryDataListNewElement) -> String {
        // Logic to determine operation type based on transaction data
        if transaction.payoutCardModel != nil {
            return "payoutCardModel"
        } else if transaction.payinCardModel != nil {
            return "payinCardModel"
        } else if transaction.receiveCryptoModel != nil {
            return "receiveCryptoModel"
        } else if transaction.sendToWalletModel != nil {
            return "sendToWalletModel"
        } else if transaction.sendToPhoneModel != nil {
            return "sendToPhoneModel"
        } else if transaction.cardIssueModel != nil {
            return "cardIssueModel"
        } else if transaction.exchangeModel != nil {
            return "exchangeModel"
        }
        // Add other conditions as needed
        return "Unknown"
    }
    
    func determineTitle(for transaction: AllTransactionHistryDataListNewElement) -> String {
        
        if transaction.payoutCardModel != nil {
            return "Withdraw to a bank card"
        } else if transaction.payinCardModel != nil {
            return "Top up via bank card"
        } else if transaction.receiveCryptoModel != nil {
            return "Top up via other crypto wallets"
        } else if transaction.sendToWalletModel != nil {
            return "Transfer to Wallet Model"
        } else if transaction.sendToPhoneModel != nil {
            return "Transfer to Phone Wallet"
        } else if transaction.cardIssueModel != nil {
            return "Payment for card issuing"
        } else if transaction.exchangeModel != nil {
            return "Exchange"
        }
        // Logic to determine title based on transaction data
        return ""
    }
    
}
