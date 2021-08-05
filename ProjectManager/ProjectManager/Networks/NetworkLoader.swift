//
//  NetworkLoader.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/08/05.
//

import Foundation

struct NetworkLoader {
    private var session: URLSession?
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private func checkValidation(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        if let error = error {
            return .failure(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(DataError.invalidResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(DataError.statusCode)
        }
        
        guard let data = data else {
            return .failure(DataError.invalidData)
        }
        return .success(data)
    }
    
    func loadData(with url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        self.session?.dataTask(with: url) { data, response, error in
            let result = self.checkValidation(data: data, response: response, error: error)
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadData(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> ()) {
        self.session?.dataTask(with: request) { data, response, error in
            let result = self.checkValidation(data: data, response: response, error: error)
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
}
