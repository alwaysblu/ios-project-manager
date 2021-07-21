//
//  ViewModel.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/07/19.
//

import Foundation

class TaskViewModel {
    let networkManager = NetworkManager()
    private var taskList: [Task] = [Task(taskTitle: "1 ToDoViewModel",
                                         taskDescription: "ToDoViewModel",
                                         taskDeadline: "ToDoViewModel"),
                                    Task(taskTitle: "2 ToDoViewModel",
                                         taskDescription: "ToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModel",
                                         taskDeadline: "2021.07.20"),
                                    Task(taskTitle: "3 ToDoViewModel",
                                         taskDescription: "ToDoViewModel",
                                         taskDeadline: "2021.07.21"),
                                    Task(taskTitle: "4 ToDoViewModel",
                                         taskDescription: "ToDoViewModel",
                                         taskDeadline: "2021.07.22"),
                                    Task(taskTitle: "5 ToDoViewModel",
                                         taskDescription: "ToDoViewModel",
                                         taskDeadline: "2020.09.09"),
                                    Task(taskTitle: "6 ToDoViewModel",
                                         taskDescription: "ToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModelToDoViewModel",
                                         taskDeadline: "2022.09.09")]
    
    func referTask(at: IndexPath) -> Task? {
        if taskList.count > at.row {
            return taskList[at.row]
        }
        return nil
    }
    
    func swapTask(firstItemOfIndex: Int, secondItemOfIndex: Int) {
        self.taskList.swapAt(firstItemOfIndex, secondItemOfIndex)
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
    
    func getTask() {
        networkManager.get { taskList in
            self.taskList.append(contentsOf: taskList)
        }
    }
    
    func postTask() {
        networkManager.post() { Task in
            
        }
    }
    
    func patchTask() {
        networkManager.patch() {
        }
    }
    
    func deleteTask() {
        networkManager.delete() {
        }
    }
}
