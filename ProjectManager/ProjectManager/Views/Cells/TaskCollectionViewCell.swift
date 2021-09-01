//
//  TaskCollectionViewCell.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/07/18.
//

import UIKit
import SwipeCellKit

final class TaskCollectionViewCell: SwipeCollectionViewCell {
    static let identifier = "TaskCollectionViewCell"
    
    enum Style {
        static let titleLabelMargin: UIEdgeInsets = .init(top: 5, left: 10, bottom: -5, right: -10)
        static let descriptionLabelMargin: UIEdgeInsets = .init(top: 5, left: 10, bottom: -5, right: -10)
        static let deadLineLabelMargin: UIEdgeInsets = .init(top: 5, left: 10, bottom: -5, right: -10)
    }
    
    private let taskTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let taskDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let taskDeadline: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var estimatedSize: CGSize = CGSize(width: 0, height: 0)
    private var isDragged = false
    private var taskID: String = ""
    
    // MARK: - Initial TaskCollectionViewCell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTaskCollectionViewCell()
        addAllSubViews()
        setAllConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - TaskCollecionViewCell Configure
    
    private func setTaskCollectionViewCell() {
        contentView.backgroundColor = .white
        layer.shadowOpacity = 1
        layer.shadowRadius = 1.0
        layer.shadowColor = UIColor.systemGray5.cgColor
    }
    
    private func addAllSubViews() {
        contentView.addSubview(self.taskTitle)
        contentView.addSubview(self.taskDescription)
        contentView.addSubview(self.taskDeadline)
    }
    
    // MARK: - Constraint
    
    private func setAllConstraint() {
        setTaskTitleLabel()
        setTaskDescriptionLabel()
        setTaskDeadlineLabel()
    }
    
    private func setTaskTitleLabel() {
        NSLayoutConstraint.activate([
            self.taskTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            self.taskTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.taskTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0),
            self.taskTitle.bottomAnchor.constraint(equalTo: self.taskDescription.topAnchor, constant: -10),
        ])
    }
    
    private func setTaskDescriptionLabel() {
        NSLayoutConstraint.activate([
            self.taskDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.taskDescription.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10),
            self.taskDescription.bottomAnchor.constraint(equalTo: self.taskDeadline.topAnchor, constant: -10),
        ])
    }

    private func setTaskDeadlineLabel() {
        NSLayoutConstraint.activate([
            self.taskDeadline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.taskDeadline.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0),
            self.taskDeadline.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: - Convert Date
        
    private func convertStringToTimeInterval1970(date: String) -> Double? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone.current
        guard let dateInDateFormat = dateFormatter.date(from: date) else { return nil }
        
        return dateInDateFormat.timeIntervalSince1970
    }
    
    private func convertDateToString(_ date: Date) -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    private func checkIfDeadlineHasPassed(deadline: String) -> Bool? {
        guard let deadline = convertStringToTimeInterval1970(date: deadline) else { return nil }
        return Date().timeIntervalSince1970 > deadline + 86400 ? true : false
    }
    
    // MARK: - Outside Methd - initial Cell Configure
    
    func configureCell(data: Task) {
        self.taskID = data.id
        let deadline = Date(timeIntervalSince1970: data.deadline)
        self.taskTitle.text = data.title
        self.taskDescription.text = data.detail
        self.taskDeadline.text = convertDateToString(deadline)
        guard let isDeadlinePassed = checkIfDeadlineHasPassed(deadline: convertDateToString(deadline)) else { return }
        taskDeadline.textColor = .black
        if isDeadlinePassed {
            taskDeadline.textColor = .red
        }
    }
}


