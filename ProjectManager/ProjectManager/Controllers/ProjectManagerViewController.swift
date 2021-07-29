//
//  ProjectManager - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProjectManagerViewController: UIViewController, TaskAddDelegate , DeleteDelegate {
    let toDoViewModel = TaskViewModel()
    let doingViewModel = TaskViewModel()
    let doneViewModel = TaskViewModel()
    let toDoHeader = TaskCollectionViewHeaderCell()
    let doingHeader = TaskCollectionViewHeaderCell()
    let doneHeader = TaskCollectionViewHeaderCell()
    let toDoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let doingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let doneCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var dragCollectionView: UICollectionView?
    var dragCollectionViewIndexPath: IndexPath?
    let addTaskViewController = AddTaskViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .systemGray4
        self.toDoCollectionView.backgroundColor = .systemGray6
        self.doingCollectionView.backgroundColor = .systemGray6
        self.doneCollectionView.backgroundColor = .systemGray6
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = .systemGray2
        self.navigationItem.title = "Project Manager"
        self.setAddTask()
        self.setCollectionViewConfigure()
        self.addTaskViewController.taskDelegate = self
        self.addSubviewInView()
        self.registerCollectionViewCell()
        self.setUpDelegate()
        self.setUpDataSource()
        self.setUpToDoCollectionView()
        self.setUpDoingCollectionView()
        self.setUpDoneCollectionView()
        self.setUpToDoHeader()
        self.setUpDoingHeader()
        self.setUpDoneHeader()
        self.setCallBackMethod()
    }
    
    private func setCallBackMethod() {
        toDoViewModel.updateTaskCollectionView = { [weak self] in
            guard let toDoCollectionView = self?.toDoCollectionView else {
                return
            }
            self?.updateCount(toDoCollectionView)
            self?.toDoCollectionView.reloadData()
        }
        
        doingViewModel.updateTaskCollectionView = { [weak self] in
            guard let doingCollectionView = self?.doingCollectionView else {
                return
            }
            self?.updateCount(doingCollectionView)
            self?.doingCollectionView.reloadData()
        }
        
        doneViewModel.updateTaskCollectionView = { [weak self] in
            guard let doneCollectionView = self?.doneCollectionView else {
                return
            }
            self?.updateCount(doneCollectionView)
            self?.doneCollectionView.reloadData()
        }
    }
    
    private func setCollectionViewConfigure() {
        guard let todoLayout = toDoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        guard let doingLayout = doingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        guard let doneLayout = doneCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        todoLayout.sectionHeadersPinToVisibleBounds = true
        doingLayout.sectionHeadersPinToVisibleBounds = true
        doneLayout.sectionHeadersPinToVisibleBounds = true
        
        toDoCollectionView.register(TaskCollectionViewHeaderCell.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: TaskCollectionViewHeaderCell.identifier)
        doingCollectionView.register(TaskCollectionViewHeaderCell.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: TaskCollectionViewHeaderCell.identifier)
        doneCollectionView.register(TaskCollectionViewHeaderCell.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: TaskCollectionViewHeaderCell.identifier)
    }

    private func setAddTask() {
        let addTaskItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        self.navigationItem.rightBarButtonItem = addTaskItem
    }
    
    @objc private func addTask() {
        addTaskViewController.modalPresentationStyle = .formSheet
        addTaskViewController.setState(mode: .add, state: .todo, data: nil, indexPath: nil)
        present(UINavigationController(rootViewController: addTaskViewController), animated: true, completion: nil)
    }
    
    func addData(_ data: Task) {
        toDoViewModel.insertTaskIntoTaskList(index: 0, task: data)
    }
    
    func updateData(state: State, indexPath: IndexPath, _ data: Task) {
        switch state {
        case .todo:
            toDoViewModel.updateTaskIntoTaskList(indexPath: indexPath, task: data)
        case .doing:
            doingViewModel.updateTaskIntoTaskList(indexPath: indexPath, task: data)
        case .done:
            doneViewModel.updateTaskIntoTaskList(indexPath: indexPath, task: data)
        }
    }
        
    func deleteTask(collectionView: UICollectionView, indexPath: IndexPath) {
        self.findViewModel(collectionView: collectionView)?.deleteTaskFromTaskList(index: indexPath.row)
    }
    
    private func addSubviewInView() {
        self.view.addSubview(toDoCollectionView)
        self.view.addSubview(doingCollectionView)
        self.view.addSubview(doneCollectionView)
        self.view.addSubview(toDoHeader)
        self.view.addSubview(doingHeader)
        self.view.addSubview(doneHeader)
    }
    
    private func registerCollectionViewCell() {
        self.toDoCollectionView.register(TaskCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
        self.doingCollectionView.register(TaskCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
        self.doneCollectionView.register(TaskCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
    }
    
    private func setUpDelegate() {
        self.toDoCollectionView.delegate = self
        self.doingCollectionView.delegate = self
        self.doneCollectionView.delegate = self
        self.toDoCollectionView.dragDelegate = self
        self.doingCollectionView.dragDelegate = self
        self.doneCollectionView.dragDelegate = self
        self.toDoCollectionView.dropDelegate = self
        self.doingCollectionView.dropDelegate = self
        self.doneCollectionView.dropDelegate = self
    }
    
    private func setUpDataSource() {
        self.toDoCollectionView.dataSource = self
        self.doingCollectionView.dataSource = self
        self.doneCollectionView.dataSource = self
    }
    
    private func setUpToDoHeader() {
        self.toDoHeader.translatesAutoresizingMaskIntoConstraints = false
        self.toDoHeader.initializeHeader("TODO", count: toDoViewModel.taskListCount())
        toDoHeader.backgroundColor = .systemGray6
        NSLayoutConstraint.activate([
            self.toDoHeader.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.toDoHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.toDoHeader.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3, constant: -20/3),
            self.toDoHeader.bottomAnchor.constraint(equalTo: self.toDoCollectionView.topAnchor, constant: -1),
        ])
    }
    
    private func setUpDoingHeader() {
        self.doingHeader.translatesAutoresizingMaskIntoConstraints = false
        self.doingHeader.initializeHeader("DOING", count: doingViewModel.taskListCount())
        doingHeader.backgroundColor = .systemGray6
        NSLayoutConstraint.activate([
            self.doingHeader.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.doingHeader.leadingAnchor.constraint(equalTo: self.doingCollectionView.leadingAnchor),
            self.doingHeader.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3, constant: -20/3),
            self.doingHeader.bottomAnchor.constraint(equalTo: self.doingCollectionView.topAnchor, constant: -1),
        ])
    }
    
    private func setUpDoneHeader() {
        self.doneHeader.translatesAutoresizingMaskIntoConstraints = false
        self.doneHeader.initializeHeader("DONE", count: doneViewModel.taskListCount())
        doneHeader.backgroundColor = .systemGray6
        NSLayoutConstraint.activate([
            self.doneHeader.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.doneHeader.leadingAnchor.constraint(equalTo: self.doneCollectionView.leadingAnchor),
            self.doneHeader.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3, constant: -20/3),
            self.doneHeader.bottomAnchor.constraint(equalTo: self.doneCollectionView.topAnchor, constant: -1),
        ])
    }
    
    private func setUpToDoCollectionView() {
        self.toDoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.toDoCollectionView.showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            self.toDoCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140),
            self.toDoCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.toDoCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3, constant: -20/3),
            self.toDoCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func setUpDoingCollectionView() {
        self.doingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.doingCollectionView.showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            self.doingCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140),
            self.doingCollectionView.leadingAnchor.constraint(equalTo: toDoCollectionView.trailingAnchor, constant: 10),
            self.doingCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3, constant: -20/3),
            self.doingCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func setUpDoneCollectionView() {
        self.doneCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.doneCollectionView.showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            self.doneCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 140),
            self.doneCollectionView.leadingAnchor.constraint(equalTo: doingCollectionView.trailingAnchor, constant: 10),
            self.doneCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.doneCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3, constant: -20/3),
            self.doneCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func findTask(collectionView: UICollectionView, indexPath:IndexPath) -> Task? {
        switch collectionView {
        case toDoCollectionView:
            return toDoViewModel.referTask(at: indexPath)
        case doingCollectionView:
            return doingViewModel.referTask(at: indexPath)
        case doneCollectionView:
            return doneViewModel.referTask(at: indexPath)
        default:
            return nil
        }
    }
    
    private func findViewModel(collectionView: UICollectionView) -> TaskViewModel? {
        switch collectionView {
        case toDoCollectionView:
            return toDoViewModel
        case doingCollectionView:
            return doingViewModel
        case doneCollectionView:
            return doneViewModel
        default:
            return nil
        }
    }
    
    func findHeader(status: UICollectionView) -> TaskCollectionViewHeaderCell? {
        switch status {
        case toDoCollectionView:
            return toDoHeader
        case doingCollectionView:
            return doingHeader
        case doneCollectionView:
            return doneHeader
        default:
            return nil
        }
    }
    
    func findCell(collectionView: UICollectionView, indexPath: IndexPath) -> TaskCollectionViewCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.identifier, for: indexPath) as? TaskCollectionViewCell else {
           return nil
        }
        return cell
    }
    
    private func removeDraggedCollectionViewItem() {
        guard let draggedCollectionView = self.dragCollectionView, let draggedCollectionViewIndexPath = self.dragCollectionViewIndexPath else {
            return
        }
        self.findViewModel(collectionView: draggedCollectionView)?.deleteTaskFromTaskList(index: draggedCollectionViewIndexPath.row)
    }
    
    private func setDraggedItemToNil() {
        self.dragCollectionView = nil
        self.dragCollectionViewIndexPath = nil
    }
}

extension ProjectManagerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addTaskViewController.mode = .edit
        addTaskViewController.modalPresentationStyle = .formSheet
        switch collectionView {
        case toDoCollectionView:
            addTaskViewController.setState(mode: .edit, state: .todo, data: toDoViewModel.referTask(at: indexPath), indexPath: indexPath)
        case doingCollectionView:
            addTaskViewController.setState(mode: .edit, state: .doing, data: doingViewModel.referTask(at: indexPath), indexPath: indexPath)
        case doneCollectionView:
            addTaskViewController.setState(mode: .edit, state: .done, data: doneViewModel.referTask(at: indexPath), indexPath: indexPath)
        default:
            return
        }
        
        present(UINavigationController(rootViewController: addTaskViewController), animated: true, completion: nil)
    }
}

extension ProjectManagerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.toDoCollectionView {
            return toDoViewModel.taskListCount()
        }
        
        if collectionView == self.doingCollectionView {
            return doingViewModel.taskListCount()
        }
        
        return doneViewModel.taskListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = toDoCollectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.identifier, for: indexPath) as? TaskCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.deleteDelegate = self
        
        if collectionView == self.toDoCollectionView {
            guard let task = toDoViewModel.referTask(at: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configureCell(with: task)
            return cell
        }
        
        if collectionView == self.doingCollectionView {
            guard let task = doingViewModel.referTask(at: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configureCell(with: task)
            return cell
        }
        
        guard let task = doneViewModel.referTask(at: indexPath) else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: task)
        return cell
    }
    
}

extension ProjectManagerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let dummyCell = TaskCollectionViewCell(frame: CGRect(x: 0, y: 0, width: width, height: 500.0))
        if let task = self.findTask(collectionView: collectionView, indexPath: indexPath) {
            dummyCell.configureCell(with: task)
        }
        return CGSize(width: width, height: dummyCell.getEstimatedHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

extension ProjectManagerViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("before 드래그: ", findCell(collectionView: collectionView, indexPath: indexPath)?.isDragged)
        findCell(collectionView: collectionView, indexPath: indexPath)?.isDragged = true
        print("after 드래그: ", findCell(collectionView: collectionView, indexPath: indexPath)?.isDragged)
        guard let task = findTask(collectionView: collectionView, indexPath: indexPath) else {
            return []
        }
        let itemProvider = NSItemProvider(object: task as Task)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragCollectionView = collectionView
        dragCollectionViewIndexPath = indexPath
        return [dragItem]
    }
}

extension ProjectManagerViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        coordinator.session.loadObjects(ofClass: Task.self) { [weak self] taskList in
            collectionView.performBatchUpdates({
                guard let task = taskList[0] as? Task,
                      let dropViewModel = self?.findViewModel(collectionView: collectionView),
                      let dragCollectionViewIndexPath = self?.dragCollectionViewIndexPath
                      else {
                    return
                }
                self?.dragCollectionView?.deleteItems(at: [dragCollectionViewIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                self?.removeDraggedCollectionViewItem()
                dropViewModel.insertTaskIntoTaskList(index: destinationIndexPath.row, task: Task(taskTitle: task.taskTitle, taskDescription: task.taskDescription, taskDeadline: task.taskDeadline))
                self?.setDraggedItemToNil()
            })
        }
    }
    
    private func updateCount(_ collectionView: UICollectionView) {
        guard let viewModel = self.findViewModel(collectionView: collectionView),
              let header = self.findHeader(status: collectionView)
        else {
            return
        }
        header.updateCount(viewModel.taskListCount())
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
}

