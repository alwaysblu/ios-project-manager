//
//  ViewModel.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/07/19.
//

import Foundation

final class TaskViewModel {
    private let service = Service()
    private var isNetworkConnected: Bool = false {
        didSet {
            updateNetworkStatus(isNetworkConnected)
        }
    }
    private var taskList: [Task] = [] {
        didSet {
            updateTaskCollectionView(oldValue, taskList)
        }
    }
    var updateTaskCollectionView : (_ oldValue:[Task], _ newValue: [Task]) -> Void = {_,_ in }
    var updateNetworkStatus: (Bool) -> Void = {_ in }
    
    func referTask(at: IndexPath) -> Task? {
        if taskList.count > at.row {
            return taskList[at.row]
        }
        return nil
    }
    
    func taskListCount() -> Int {
        return taskList.count
    }
    
    func insertTaskIntoTaskList(index: Int, task: Task) {
        taskList.insert(task, at: index)
    }
    
    func deleteTaskFromTaskList(index: Int) {
        taskList.remove(at: index)
    }
    
    func updateTaskIntoTaskList(indexPath: IndexPath, task: Task) {
        taskList[indexPath.row] = task
    }
    
    func getTask(status: State) {
        service.getTask(status: status) { [weak self] tasks, isNetworkConnected in
            self?.taskList.append(contentsOf: tasks)
            self?.isNetworkConnected = isNetworkConnected
        }
    }
    
    func postTask(task: Task) {
        service.postTask(task: task) { [weak self] isNetworkConnected in
            self?.isNetworkConnected = isNetworkConnected
        }
    }
    
    func patchTask(task: Task) {
        service.patchTask(task: task) { [weak self] isNetworkConnected in
            self?.isNetworkConnected = isNetworkConnected
        }
    }
    
    func deleteTask(id: String) {
        service.deleteTask(id: id) { [weak self] isNetworkConnected in
            self?.isNetworkConnected = isNetworkConnected
        }
    }
}
