//
//  CountryViewModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/08/23.
//

import Foundation
import Combine

class CountryCodeViewModel: ObservableObject {
    // Combine publisher to emit the countries data
    @Published private(set) var countries: Countries = []
    private var cancellables = Set<AnyCancellable>()
    
    func getCountryCode() {
        // Path to Country code json file
        if let path = Bundle.main.path(forResource: "country_codes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) // Converting json to data
                
                // Use Combine's Future to handle decoding and completion
                let countriesFuture = Future<Countries, Error> { promise in
                    do {
                        let decodedCountries = try JSONDecoder().decode(Countries.self, from: data) // decoding data to model
                        promise(.success(decodedCountries))
                    } catch {
                        promise(.failure(error))
                    }
                }
                
                // Sink to receive the result of the Future and update the @Published property
                countriesFuture
                    .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
                    .sink(receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            print(error)
                        }
                    }, receiveValue: { [weak self] countries in
                        self?.countries = countries
                    })
                    .store(in: &cancellables)
                
            } catch {
                print(error)
            }
        } else {
            print("Fail:- Country Code Not loaded from file. File not found [ CVM : 27]")
        }
    }
}
