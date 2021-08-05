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

    private func setUpNotificationCenterPost() {
        let networkStatusNotification = NSNotification.Name.init("network Status")
        NotificationCenter.default.post(name: networkStatusNotification, object: nil)
    }
    private func encodedData<T>(data: T) -> Data? where T: Encodable{
        let encoder = JSONEncoder()
        return try? encoder.encode(data)
    }
    
    func get(completion: @escaping (Result<[Task], Error>) -> ()) {
        let urlString = Secret.baseURL + "/tasks"
        guard let url = URL(string: urlString) else {
            return
        }
        self.indicatorView.showIndicator()
        networkLoader.loadData(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let tasks = try JSONDecoder().decode([Task].self, from: data)
                    self.indicatorView.dismiss()
                    completion(.success(tasks))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func post(task: Task, completion: @escaping (Result<Task, Error>) -> ()) {
        let urlString = Secret.baseURL + "/tasks"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var requset = URLRequest(url: url)
        
        requset.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requset.httpMethod = "POST"
        requset.httpBody = encodedData(data: task)
        networkLoader.loadData(with: requset) { result in
            switch result {
            case .success(let data):
                do {
                    let task = try JSONDecoder().decode(Task.self, from: data)
                    completion(.success(task))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func patch(task: Task, completion: @escaping (Result<Task, Error>) -> ()) {
        let urlString = Secret.baseURL + "/tasks" + "/\(task.id)"
        guard let url = URL(string: urlString) else {
            return
        }
        var requset = URLRequest(url: url)
        
        requset.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requset.httpMethod = "PATCH"
        requset.httpBody = encodedData(data: task)
        networkLoader.loadData(with: requset) { result in
            switch result {
            case .success(let data):
                do {
                    let task = try JSONDecoder().decode(Task.self, from: data)
                    completion(.success(task))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func delete(id: String, completion: @escaping (Bool) -> ()) {
        let urlString = Secret.baseURL + "/tasks" + "/\(id)"
        guard let url = URL(string: urlString) else {
            return
        }
        var requset = URLRequest(url: url)
        
        requset.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requset.httpMethod = "DELETE"
        networkLoader.loadData(with: requset) { result in
            networkLoader.loadData(with: requset) { result in
                switch result {
                case .success(_):
                    completion(true)
                case .failure(_):
                    completion(false)
                }
            }
        }
    }
}

