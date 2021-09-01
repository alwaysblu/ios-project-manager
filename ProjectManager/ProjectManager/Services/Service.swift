//
//  Service.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/07/31.
//

import Foundation

struct Service {
    private let networkManager = NetworkManager()
    private let coreDataManager = CoreData()
    
    func getTask(status: State, completion: @escaping ([Task], Bool) -> ()) {
        requestOperationstoServerInBuffer()
        networkManager.get { result in
            guard let diskCacheTaskDataList = coreDataManager.getTaskList(),
                  let disCacheTaskList = convertTaskDataListToTaskList(taskDataList: diskCacheTaskDataList) else {
                return
            }
            
            switch result {
            case .success(let tasks):
                let filteredTaskList = filterTaskData(status: status, taskList: tasks)
                completion(filteredTaskList, true)
            case .failure(_):
                let filteredTaskList = filterTaskData(status: status, taskList: disCacheTaskList)
                completion(filteredTaskList, false)
            }
        }
    }
    
    func postTask(task: Task, completion: @escaping (Bool) -> Void) {
        requestOperationstoServerInBuffer()
        coreDataManager.createTask(task: task)
        networkManager.post(task: task) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                pushIntoBuffer(task: task, httpMethod: "POST")
                completion(false)
            }
        }
    }
    
    func patchTask(task: Task, completion: @escaping (Bool) -> Void) {
        requestOperationstoServerInBuffer()
        coreDataManager.patchData(task: task)
        networkManager.patch(task: task) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                pushIntoBuffer(task: task, httpMethod: "POST")
                completion(false)
            }
        }
    }
    
    func deleteTask(id: String, completion: @escaping (Bool) -> Void) {
        requestOperationstoServerInBuffer()
        coreDataManager.deleteTask(id: id)
        networkManager.delete(id: id) { result in
            guard result else {
                let mockTask = Task(title: "", detail: "", deadline: 0, status: "", id: id)
                pushIntoBuffer(task: mockTask, httpMethod: "DELETE")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func filterTaskData(status: State, taskList: [Task]) -> [Task]{
        switch status {
        case .todo:
            return taskList.filter{$0.status == State.todo.rawValue}
        case .doing:
            return taskList.filter{$0.status == State.doing.rawValue}
        case .done:
            return taskList.filter{$0.status == State.done.rawValue}
        }
    }
    
    func requestOperationstoServerInBuffer() {
        guard let bufferItems = coreDataManager.getBufferItems() else {
            return
        }
        for bufferItem in bufferItems {
            guard let title = bufferItem.title,
                  let detail = bufferItem.detail,
                  let status = bufferItem.status,
                  let id = bufferItem.id,
                  let httpMethod = bufferItem.httpMethod else {
                return
            }
            let task = Task(title: title, detail: detail, deadline: bufferItem.deadline, status: status, id: id)
            performHttpMethodAction(task: task, httpMethod: httpMethod)
        }
    }
    
    func performHttpMethodAction(task: Task, httpMethod: String) {
        switch httpMethod {
        case "POST":
            networkManager.post(task: task) { result in
                switch result {
                case .success(_):
                    coreDataManager.popFromBuffer(id: task.id)
                case .failure(_):
                    return
                }
            }
        case "PATCH":
            networkManager.patch(task: task) { result in
                switch result {
                case .success(_):
                    coreDataManager.popFromBuffer(id: task.id)
                case .failure(_):
                    return
                }
            }
        case "DELETE":
            networkManager.delete(id: task.id) { networkStatus in
                guard networkStatus else {
                    return
                }
                coreDataManager.popFromBuffer(id: task.id)
            }
        default:
            return
        }
    }
    
    func convertTaskDataToTask(taskData: TaskData) -> Task? {
        guard let title = taskData.title,
              let detail = taskData.detail,
              let status = taskData.status,
              let id = taskData.id else {
            return nil
        }
        return Task(title: title, detail: detail, deadline: taskData.deadline, status: status, id: id)
    }
    
    func convertTaskDataListToTaskList(taskDataList: [TaskData]) -> [Task]? {
        var taskList: [Task] = []
        for taskData in taskDataList {
            guard let taskData = convertTaskDataToTask(taskData: taskData) else {
                return nil
            }
            taskList.append(taskData)
        }
        return taskList
    }
    
    func pushIntoBuffer(task: Task, httpMethod: String) {
        coreDataManager.pushIntoBuffer(task: task, httpMethod: httpMethod)
    }
    
    func popFromBuffer(id: String) {
        coreDataManager.popFromBuffer(id: id)
    }
}
