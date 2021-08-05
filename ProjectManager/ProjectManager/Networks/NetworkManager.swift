//
//  NetworkManager.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/07/19.
//

import Foundation

struct NetworkManager {
    private let networkLoader = NetworkLoader()
    private let indicatorView = IndicatorView()
    private let baseURL = "https://vaporpms.herokuapp.com"
    
    private func setUpNotificationCenterPost() {
        let networkStatusNotification = NSNotification.Name.init("network Status")
        NotificationCenter.default.post(name: networkStatusNotification, object: nil)
    }
    private func encodedData<T>(data: T) -> Data? where T: Encodable{
        let encoder = JSONEncoder()
        return try? encoder.encode(data)
    }
    
    func get(completion: @escaping (Result<[Task], Error>) -> ()) {
        let urlString = baseURL + "/tasks"
        guard let url = URL(string: urlString) else {
            return
        }
        self.indicatorView.showIndicator()
        networkLoader.loadData(with: url) { result in
            switch result {
            case .success(let tasks):
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func post(task: Task, completion: @escaping (Result<Task, Error>) -> ()) {
        let urlString = baseURL + "/tasks"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var requset = URLRequest(url: url)
        
        requset.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requset.httpMethod = "POST"
        requset.httpBody = encodedData(data: task)
        networkLoader.loadData(with: requset) { result in
            switch result {
            case .success(let task):
                completion(.success(task))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func patch(task: Task, completion: @escaping (Result<Task, Error>) -> ()) {
        let urlString = baseURL + "/tasks" + "/\(task.id)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var requset = URLRequest(url: url)
        
        requset.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requset.httpMethod = "PATCH"
        requset.httpBody = encodedData(data: task)
        networkLoader.loadData(with: requset) { result in
            switch result {
            case .success(let task):
                completion(.success(task))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func delete(id: String, completion: @escaping (Bool) -> ()) {
        let urlString = baseURL + "/tasks" + "/\(id)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var requset = URLRequest(url: url)
        
        requset.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requset.httpMethod = "DELETE"
        networkLoader.loadData(with: requset) { result in
            networkLoader.loadData(with: requset) { result in
                switch result {
                case .success():
                    return true
                case .failure():
                    return false
                }
            }
        }
    }
}

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
    
    func loadData(with url: URL, completion: @escaping (Result<[Task], Error>) -> ()) {
        self.session?.dataTask(with: url) { data, response, error in
            let result = self.checkValidation(data: data, response: response, error: error)
            switch result {
            case .success(let data):
                do {
                    let tasks = try JSONDecoder().decode([Task].self, from: data)
                    completion(.success(tasks))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadData<T>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> ()) where T: Decodable {
        self.session?.dataTask(with: request) { data, response, error in
            let result = self.checkValidation(data: data, response: response, error: error)
            switch result {
            case .success(let data):
                do {
                    let task = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(task))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadData(with request: URLRequest, completion: @escaping (Result<Bool, Error>) -> ()) {
        self.session?.dataTask(with: request) { data, response, error in
            let result = self.checkValidation(data: data, response: response, error: error)
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
}
