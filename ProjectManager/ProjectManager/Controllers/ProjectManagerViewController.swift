//
//  ProjectManager - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProjectManagerViewController: UIViewController, TaskAddDelegate, DeleteDelegate, TaskHistoryDelegate {
    enum Style {
        static let headerViewWidthMultiplier: CGFloat = 1/3
        static let headerViewEachMargin: CGFloat = -20/3
        static let headerViewHeightMultiplier: CGFloat = 1/16
        static let collectionAndHeaderSpace: CGFloat = 3
    }
    
    private let toDoCollectionView: UICollectionView = {
        let collecionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collecionView.backgroundColor = .systemGray6
        collecionView.translatesAutoresizingMaskIntoConstraints = false
        collecionView.showsVerticalScrollIndicator = false
        collecionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
        return collecionView
    }()
    private let doingCollectionView: UICollectionView = {
        let collecionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collecionView.backgroundColor = .systemGray6
        collecionView.translatesAutoresizingMaskIntoConstraints = false
        collecionView.showsVerticalScrollIndicator = false
        collecionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
        return collecionView
    }()
    private let doneCollectionView: UICollectionView = {
        let collecionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collecionView.backgroundColor = .systemGray6
        collecionView.translatesAutoresizingMaskIntoConstraints = false
        collecionView.showsVerticalScrollIndicator = false
        collecionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
        return collecionView
    }()
    private let toDoHeader: TaskHeader = {
        let header = TaskHeader(title: "TODO")
        header.backgroundColor = .systemGray6
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    private let doingHeader: TaskHeader = {
        let header = TaskHeader(title: "DOING")
        header.backgroundColor = .systemGray6
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    private let doneHeader: TaskHeader = {
        let header = TaskHeader(title: "DONE")
        header.backgroundColor = .systemGray6
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    private let toDoViewModel = TaskViewModel()
    private let doingViewModel = TaskViewModel()
    private let doneViewModel = TaskViewModel()
    private var taskHistoryViewModel = TaskHistoryViewModel()
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectManagerViewControllerConfigure()
        setAddTask()
        setHistory()
        setHeaderView()
        setCollecionView()
        setDataBindingWithViewModel()
    }
    
    // MARK: - Data Binding
    
    private func setDataBindingWithViewModel() {
        toDoViewModel.updateTaskCollectionView = { [weak self] in
            self?.updateCount(self!.toDoCollectionView)
        }
        doingViewModel.updateTaskCollectionView = { [weak self] in
            self?.updateCount(self!.doingCollectionView)
        }
        doneViewModel.updateTaskCollectionView = { [weak self] in
            self?.updateCount(self!.doneCollectionView)
        }
    }
    
    func updateData(state: State, indexPath: IndexPath, _ data: Task) {
        switch state {
        case .todo:
            self.toDoViewModel.updateTaskIntoTaskList(indexPath: indexPath, task: data)
            self.toDoCollectionView.reloadItems(at: [indexPath])
        case .doing:
            self.doingViewModel.updateTaskIntoTaskList(indexPath: indexPath, task: data)
            self.doingCollectionView.reloadItems(at: [indexPath])
        case .done:
            self.doneViewModel.updateTaskIntoTaskList(indexPath: indexPath, task: data)
            self.doneCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    // MARK: - Cell Update & Delete
    
    func deleteTask(collectionView: UICollectionView, indexPath: IndexPath, taskID: String, taskTitle: String) {
        self.findViewModel(collectionView: collectionView)?.deleteTaskFromTaskList(index: indexPath.row, taskID: taskID)
        switch collectionView {
        case toDoCollectionView:
            taskHistoryViewModel.deleted(title: taskTitle, from: .todo)
        case doingCollectionView:
            taskHistoryViewModel.deleted(title: taskTitle, from: .doing)
        case doneCollectionView:
            taskHistoryViewModel.deleted(title: taskTitle, from: .done)
        default:
            return
        }
        collectionView.deleteItems(at: [indexPath])
    }
    
    private func updateCount(_ collectionView: UICollectionView) {
        guard let viewModel = self.findViewModel(collectionView: collectionView),
              let header = self.findHeader(status: collectionView)
        else {
            return
        }
        header.updateCount(viewModel.taskListCount())
    }
    
    // MARK: - SuperView Add Button Action
    
    private func setAddTask() {
        let addTaskItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        self.navigationItem.rightBarButtonItem = addTaskItem
    }
    
    @objc private func addTask() {
        let addTaskViewController = TaskDetailViewController()
        addTaskViewController.taskDelegate = self
        addTaskViewController.taskHistoryDelegate = self
        addTaskViewController.modalPresentationStyle = .formSheet
        addTaskViewController.setState(mode: .add, state: .todo, data: nil, indexPath: nil)
        present(UINavigationController(rootViewController: addTaskViewController), animated: true, completion: nil)
    }
    
    func addData(_ data: Task) {
        self.toDoViewModel.insertTaskIntoTaskList(index: 0, task: data)
        self.toDoCollectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
    }
    
    // MARK: - SuperView History Button Action
    
    private func setHistory() {
        let historyItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(taskHistory))
        self.navigationItem.leftBarButtonItem = historyItem
    }
    
    @objc private func taskHistory() {
        let historyViewController = TaskHistoryViewController()
        historyViewController.taskHistoryDelegate = self
        historyViewController.modalPresentationStyle = .popover
        historyViewController.preferredContentSize = CGSize(width: self.view.frame.width * 3/7, height: self.view.frame.height * 3/5)
        historyViewController.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        
        self.present(historyViewController, animated: true, completion: nil)
    }
    
    func addedHistory(title: String) {
        self.taskHistoryViewModel.added(title: title)
    }
    
    func updatedHistory(atTitle: String, toTitle: String, from: State) {
        self.taskHistoryViewModel.updated(atTitle: atTitle, toTitle: toTitle, from: from)
    }
    
    func historyCount() -> Int {
        self.taskHistoryViewModel.taskHistoryCount
    }
    
    func referHistory(index: IndexPath) -> TaskHistory {
        self.taskHistoryViewModel.referTaskHistory(index: index)
    }
    
    // MARK: - Initial Configure
    
    private func projectManagerViewControllerConfigure() {
        self.view.backgroundColor = .systemGray4
        self.navigationController?.navigationBar.backgroundColor = .systemGray2
        self.navigationItem.title = "Project Manager"
        self.setDelegate()
        self.setDataSource()
    }
    
    private func setCollecionView() {
        self.setToDoCollectionView()
        self.setDoingCollectionView()
        self.setDoneCollectionView()
    }
    
    private func setHeaderView() {
        self.setToDoHeader()
        self.setDoingHeader()
        self.setDoneHeader()
    }
    
    private func setDelegate() {
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
    
    private func setDataSource() {
        self.toDoCollectionView.dataSource = self
        self.doingCollectionView.dataSource = self
        self.doneCollectionView.dataSource = self
    }
    
    // MARK: - HeaderView Constraint
    
    private func setToDoHeader() {
        self.view.addSubview(toDoHeader)
        self.toDoHeader.updateCount(toDoViewModel.taskListCount())
        NSLayoutConstraint.activate([
            self.toDoHeader.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.toDoHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.toDoHeader.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: Style.headerViewWidthMultiplier, constant: Style.headerViewEachMargin),
            self.toDoHeader.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: Style.headerViewHeightMultiplier)
        ])
    }
    
    private func setDoingHeader() {
        self.view.addSubview(doingHeader)
        self.doingHeader.updateCount(doingViewModel.taskListCount())
        NSLayoutConstraint.activate([
            self.doingHeader.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.doingHeader.leadingAnchor.constraint(equalTo: self.toDoHeader.trailingAnchor, constant: 10),
            self.doingHeader.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: Style.headerViewWidthMultiplier, constant: Style.headerViewEachMargin),
            self.doingHeader.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: Style.headerViewHeightMultiplier)
        ])
    }
    
    private func setDoneHeader() {
        self.view.addSubview(doneHeader)
        self.doneHeader.updateCount(doneViewModel.taskListCount())
        NSLayoutConstraint.activate([
            self.doneHeader.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.doneHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.doneHeader.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: Style.headerViewWidthMultiplier, constant: Style.headerViewEachMargin),
            self.doneHeader.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: Style.headerViewHeightMultiplier)
            
        ])
    }
    
    // MARK: - CollectionView Constraint
    
    private func setToDoCollectionView() {
        self.view.addSubview(toDoCollectionView)
        NSLayoutConstraint.activate([
            self.toDoCollectionView.topAnchor.constraint(equalTo: toDoHeader.bottomAnchor, constant: Style.collectionAndHeaderSpace),
            self.toDoCollectionView.centerXAnchor.constraint(equalTo: toDoHeader.centerXAnchor),
            self.toDoCollectionView.widthAnchor.constraint(equalTo: toDoHeader.widthAnchor),
            self.toDoCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setDoingCollectionView() {
        self.view.addSubview(doingCollectionView)
        NSLayoutConstraint.activate([
            self.doingCollectionView.topAnchor.constraint(equalTo: doingHeader.bottomAnchor, constant: Style.collectionAndHeaderSpace),
            self.doingCollectionView.centerXAnchor.constraint(equalTo: doingHeader.centerXAnchor),
            self.doingCollectionView.widthAnchor.constraint(equalTo: doingHeader.widthAnchor),
            self.doingCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func setDoneCollectionView() {
        self.view.addSubview(doneCollectionView)
        NSLayoutConstraint.activate([
            self.doneCollectionView.topAnchor.constraint(equalTo: doneHeader.bottomAnchor, constant: Style.collectionAndHeaderSpace),
            self.doneCollectionView.centerXAnchor.constraint(equalTo: doneHeader.centerXAnchor),
            self.doneCollectionView.widthAnchor.constraint(equalTo: doneHeader.widthAnchor),
            self.doneCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    // MARK: - Find Method
    
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
    
    func findHeader(status: UICollectionView) -> TaskHeader? {
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
}

// MARK: - CollectionView DataSource

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
            cell.configureCell(data: task)
            return cell
        }
        
        if collectionView == self.doingCollectionView {
            guard let task = doingViewModel.referTask(at: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configureCell(data: task)
            return cell
        }
        
        guard let task = doneViewModel.referTask(at: indexPath) else {
            return UICollectionViewCell()
        }

        cell.configureCell(data: task)
        
        return cell
    }
}

// MARK: - CollectionView Delegate

extension ProjectManagerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addTaskViewController = TaskDetailViewController()
        addTaskViewController.taskDelegate = self
        addTaskViewController.taskHistoryDelegate = self
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

// MARK: - CollectionView FlowLayout Delegate

extension ProjectManagerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedHeight: CGFloat = 300.0
        let width = collectionView.frame.width * 0.95
        let dummyCell = TaskCollectionViewCell(frame: CGRect(x: 0, y: 0, width: width, height: 500.0))
        guard let task = self.findTask(collectionView: collectionView, indexPath: indexPath) else { return CGSize() }
        dummyCell.configureCell(data: task)
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: width, height: estimatedHeight))

        return CGSize(width: width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - CollectionView DragDelegate

extension ProjectManagerViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let task = findTask(collectionView: collectionView, indexPath: indexPath) else {
            return []
        }
        session.localContext = TaskDragCoordinator(sourceIndexPath: indexPath, draggedCollectionView: collectionView)
        let itemProvider = NSItemProvider(object: task as Task)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
}

// MARK: - CollectionView DropDelegate

extension ProjectManagerViewController: UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: collectionView.numberOfItems(inSection: 0), section: 0)
        guard let dragCoordinator = coordinator.session.localDragSession?.localContext as? TaskDragCoordinator else { return }
        let draggedCollectionView = dragCoordinator.draggedCollectionView
        let sourceIndexPath = dragCoordinator.sourceIndexPath
        guard let dragCollectionView = judgeCollecionView(draggedCollectionView), let dropCollectionView = judgeCollecionView(collectionView) else { return }
        coordinator.session.loadObjects(ofClass: Task.self) { [weak self] taskList in
            collectionView.performBatchUpdates({
                guard let task = taskList[0] as? Task,
                      let dropViewModel = self?.findViewModel(collectionView: collectionView)
                else {
                    return
                }
                dragCoordinator.draggedCollectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                self?.findViewModel(collectionView: draggedCollectionView)?.deleteTaskFromTaskList(index: sourceIndexPath.row, taskID: task.taskID)
                dropViewModel.insertTaskIntoTaskList(index: destinationIndexPath.row, task: Task(taskTitle: task.taskTitle, taskDescription: task.taskDescription, taskDeadline: task.taskDeadline, taskID: task.taskID))
                self?.taskHistoryViewModel.moved(title: task.taskTitle, at: dragCollectionView, to: dropCollectionView)
            })
        }
    }
    
    private func judgeCollecionView(_ collectionView: UICollectionView) -> State? {
        switch collectionView {
        case toDoCollectionView:
            return .todo
        case doingCollectionView:
            return .doing
        case doneCollectionView:
            return .done
        default:
            return nil
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
}

