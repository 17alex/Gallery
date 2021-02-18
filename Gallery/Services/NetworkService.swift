//
//  NetworkManager.swift
//  Gallery
//
//  Created by Alex on 16.02.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    func loadFotos(fromUrlString: String, complete: @escaping (Result<Response, Error>) -> Void)
}

class NetworkService {
    
    private func onMain(_ blok: @escaping () -> Void) {
        DispatchQueue.main.async {
            blok()
        }
    }
}

//MARK: - NetworkServiceProtocol

extension NetworkService: NetworkServiceProtocol {
    
    func loadFotos(fromUrlString: String, complete: @escaping (Result<Response, Error>) -> Void) {
        print("url = \(fromUrlString)")
        let url = URL(string: fromUrlString)!
        var request = URLRequest(url: url, timeoutInterval: 90)
        request.httpMethod = "GET"
        request.addValue(Constans.apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, request, error) in
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else if let data = data {
                if let response = Response(data: data) {
                    self.onMain { complete(.success(response)) }
                }
            }
        }.resume()
    }
}
