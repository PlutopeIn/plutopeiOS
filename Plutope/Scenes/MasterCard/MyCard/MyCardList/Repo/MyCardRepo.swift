//
//  MyCardRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//

import Foundation
import DGNetworkingServices

class MyCardRepo {

    func apiGetCountris(completion: @escaping(Int,String,[CountryList]?) -> Void) {
       
        let apiUrl = "https://countriesnow.space/api/v0.1/countries/"
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { result in
            
            switch result {
                
            case .success((_, let response)):
                do {
                  
                    let decodeResult = try JSONDecoder().decode(CountryListData.self, from: response)
                    if decodeResult.error == false {
                        completion(1,decodeResult.msg ?? "",decodeResult.data)
                    } else {
                        completion(0,decodeResult.msg ?? "",nil)
                    }
                    
                } catch(let error) {
                    
                    print(error)
                    completion(0, error.localizedDescription,nil)
                }
            case .failure(let error):
               
                print(error)
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error.rawValue,nil)
                }
            }
        }
    }
    func apiChangeCurrency(currencies:String?,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.changeCurrency
        var parameter = [String:Any]()
        parameter["primaryCurrency"] = currencies
        print("ChangeCurrencyParam =",parameter)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    let datavalue = data?["data"] as? [String: Any]
                    if status == 200 {
                        completion(1,"")
                    } else if status  == 401 {
                        logoutApp()
                    } else {
                        completion(0,msg ?? "")
                    }
                } catch(let error) {
                    print(error)
                    completion(0,error.localizedDescription)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.")
                } else {
                    completion(0,error?.rawValue ?? "")
                }
            }
        }
    }
    func apiGetDashboardImages(completion: @escaping(Int,String,[String]?) -> Void) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.cardDashboardImages
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { result in
            
            switch result {
            case .success((_, let response)):
                do {
                    let decodeResult = try JSONDecoder().decode(DashboardImageData.self, from: response)
                    if decodeResult.status == 200 {
                        completion(1,decodeResult.message ?? "",decodeResult.data)
                    } else if decodeResult.status  == 401 {
                        logoutApp()
                    } else {
                        completion(0,decodeResult.message ?? "",nil)
                    }
                } catch(let error) {
                    print(error)
                    completion(0, error.localizedDescription,nil)
                }
            case .failure(let error):
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error.rawValue,nil)
                }
            }
        }
    }
    
  
       
}
