//
//  AddTaskViewController.swift
//  ProjectManager
//
//  Created by Fezravien on 2021/07/20.
//

import UIKit

final class TaskDetailViewController: UIViewController {
    enum Mode {
        case add
        case edit
    }

    enum EdgeInsert {
        static let descriptionContent: UIEdgeInsets = .init(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    private var taskTitle: String?
    private var taskDescription: String?
    private var taskID: String?
    private let titleTextField: UITextField = {
        let title = UITextField(frame: .zero)
        title.placeholder = "Write Title ..."
        title.borderStyle = UITextField.BorderStyle.roundedRect
        title.backgroundColor = UIColor.white
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.layer.shadowOpacity = 1
        title.layer.shadowRadius = 4.0
        title.layer.shadowColor = UIColor.black.cgColor
        title.translatesAutoresizingMaskIntoConstraints = false
        title.autocorrectionType = .no
        return title
    }()
    private let deadLineDatePickerView: UIDatePicker = {
        let date = UIDatePicker(frame: .zero)
        date.preferredDatePickerStyle = .wheels
        date.datePickerMode = .date
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    private let descriptionTextView: UITextView = {
        let description = UITextView(frame: .zero)
        description.clipsToBounds = false
        description.layer.cornerRadius = 20
        description.layer.shadowOpacity = 0.8
        description.layer.shadowOffset = CGSize(width: description.frame.width, height: description.frame.height)
        description.font = UIFont.preferredFont(forTextStyle: .subheadline)
        description.contentInset = EdgeInsert.descriptionContent
        description.translatesAutoresizingMaskIntoConstraints = false
        description.autocorrectionType = .no
        return description
    }()
    var taskDelegate: TaskAddDelegate?
    var taskHistoryDelegate: TaskHistoryDelegate?
    private var mode: Mode?
    private var state: State?
    private var currentData: Task?
    private var editIndexPath: IndexPath?
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTaskDetailViewControllerConfigure()
        setDelegate()
        setConstraint()
        tapGestureAtKeyboardAnyWhere()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItem()
        checkMode()
    }
    
    // MARK: - Initial Configure
    
    private func setTaskDetailViewControllerConfigure() {
        self.view.backgroundColor = .white
    }
    
    private func setDelegate() {
        self.titleTextField.delegate = self
        self.descriptionTextView.delegate = self
    }
    
    private func setConstraint() {
        titleTextFieldConstraint()
        deadLineDatePickerViewConstraint()
        descriptionTextViewConstraint()
    }
    
    private func checkMode() {
        guard let currentData = self.currentData else {
            return
        }
        if self.mode == .edit {
            self.titleTextField.text = currentData.title
            self.titleTextField.isEnabled = false
            self.descriptionTextView.text = currentData.detail
            self.descriptionTextView.isEditable = false
            self.deadLineDatePickerView.setDate(Date(timeIntervalSince1970: currentData.deadline), animated: true)
            self.deadLineDatePickerView.isEnabled = false
            return
        }
        self.titleTextField.isEnabled = true
        self.descriptionTextView.isEditable = true
        self.deadLineDatePickerView.isEnabled = true
    }
    
    private func setNavigationItem() {
        self.navigationItem.leftBarButtonItem?.tintColor = .systemBlue
        let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCloseButton))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEditButton))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        self.navigationItem.leftBarButtonItem = closeButton
        if self.mode == .edit {
            self.navigationItem.leftBarButtonItem = editButton
        }
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    private func tapGestureAtKeyboardAnyWhere() {
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Constraint
    
    private func titleTextFieldConstraint() {
        self.view.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            self.titleTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            self.titleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.titleTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.titleTextField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/16)
        ])
    }
    
    private func deadLineDatePickerViewConstraint() {
        self.view.addSubview(deadLineDatePickerView)
        NSLayoutConstraint.activate([
            self.deadLineDatePickerView.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor),
            self.deadLineDatePickerView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 25),
            self.deadLineDatePickerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/5),
            self.deadLineDatePickerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2)
        ])
    }
    
    private func descriptionTextViewConstraint() {
        self.view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            self.descriptionTextView.centerXAnchor.constraint(equalTo: deadLineDatePickerView.centerXAnchor),
            self.descriptionTextView.topAnchor.constraint(equalTo: deadLineDatePickerView.bottomAnchor, constant: 25),
            self.descriptionTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15),
            self.descriptionTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        ])
    }
    
    // MARK: - Outside Method
    
    func setState(mode: Mode, state: State, data: Task?, indexPath: IndexPath?) {
        self.mode = mode
        self.state = state
        self.currentData = data
        self.editIndexPath = indexPath
        if let taskID = data?.id {
            self.taskID = taskID
        }
    }
 
    // MARK: - Button Event
    
    @objc private func tapEditButton() {
        titleTextField.isEnabled = true
        descriptionTextView.isEditable = true
        deadLineDatePickerView.isEnabled = true
        navigationItem.leftBarButtonItem?.tintColor = .gray
    }
    
    @objc private func tapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func tapDoneButton() {
        guard let title = self.titleTextField.text, let detail = self.descriptionTextView.text else { return }

        if title.count > 100 {
            taskDetailErrorAlert(title: "⚠️", message: "Title Error: 100자 이상")
            return
        } else if title.count == 0 {
            taskDetailErrorAlert(title: "⚠️", message: "Title Error: 비어있습니다.")
            return
        }

        if detail.count > 1000 {
            taskDetailErrorAlert(title: "⚠️", message: "Description Error: 1000자 이상.")
            return
        } else if detail.count == 0 {
            taskDetailErrorAlert(title: "⚠️", message: "Description Error: 비어있습니다.")
            return
        }
        
        if deadLineDatePickerView.date < Date(timeIntervalSince1970: 1625497069) {
            taskDetailErrorAlert(title: "⚠️", message: "Date Error: 2021년 7월 6일 이후로 시간을 설정해주세요")
            return
        }
        
        dismiss(animated: true) {
            guard let state = self.state else {
                return
            }
            var id = self.generateId()
            if let taskId = self.currentData?.id {
                id = taskId
            } else {
                
            }
            let deadline = self.deadLineDatePickerView.date.timeIntervalSince1970

            if self.mode == .add {
                let data = Task(title: title, detail: detail, deadline: deadline, status: State.todo.rawValue, id: id)
                self.taskHistoryDelegate?.addedHistory(title: title)
                self.taskDelegate?.addData(data)
            }
            
            if self.mode == .edit {
                guard let identifier = self.taskID,
                      let indexPath = self.editIndexPath,
                      let beforeData = self.currentData else {
                    
                    return
                }
                let data = Task(title: title, detail: detail, deadline: deadline, status: state.rawValue, id: identifier)
                switch self.state {
                case .todo:
                    self.taskHistoryDelegate?.updatedHistory(atTitle: beforeData.title, toTitle: title, from: .todo)
                    self.taskDelegate?.updateData(state: .todo, indexPath: indexPath, data)
                case .doing:
                    self.taskHistoryDelegate?.updatedHistory(atTitle: beforeData.title, toTitle: title, from: .doing)
                    self.taskDelegate?.updateData(state: .doing, indexPath: indexPath, data)
                case .done:
                    self.taskHistoryDelegate?.updatedHistory(atTitle: beforeData.title, toTitle: title, from: .done)
                    self.taskDelegate?.updateData(state: .done, indexPath: indexPath, data)
                case .none:
                    return
                }
            }
        }
    }
    
    private func validateId(uuid: String) -> Bool {
        return true
    }
    
    private func generateId() -> String {
        let id = UUID().uuidString
        if validateId(uuid: id) {
            return id
        }
        return generateId()
    }
    
    private func taskDetailErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - TextField Delegate

extension TaskDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        taskTitle = text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

// MARK: - TextView Delegate

extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        taskDescription = text
    }
}
