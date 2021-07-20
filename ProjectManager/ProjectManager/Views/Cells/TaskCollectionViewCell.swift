//
//  TaskCollectionViewCell.swift
//  ProjectManager
//
//  Created by 최정민 on 2021/07/18.
//

import Foundation
import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    static let identifier = "TaskCollectionViewCell"
    var taskTitle = UILabel()
    var taskDescription = UILabel()
    var taskDeadline = UILabel()
    var cellLabel: UILabel!
    var pan: UIPanGestureRecognizer!
    var deleteLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func setUpUI() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        self.addSubviewInContentView()
        self.setUpTaskTitleLabel(layoutGuide: safeArea)
        self.setUpTaskDescriptionLabel(layoutGuide: safeArea)
        self.setUpTaskDeadlineLabel(layoutGuide: safeArea)
    }
    
    private func addSubviewInContentView() {
        self.contentView.addSubview(taskTitle)
        self.contentView.addSubview(taskDescription)
        self.contentView.addSubview(taskDeadline)
    }
    
    private func setUpTaskTitleLabel(layoutGuide: UILayoutGuide) {
        taskTitle.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        taskTitle.textColor = .label
        taskTitle.translatesAutoresizingMaskIntoConstraints = false
        taskTitle.numberOfLines = 1
        NSLayoutConstraint.activate([
            taskTitle.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 5),
            taskTitle.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            taskTitle.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            taskTitle.bottomAnchor.constraint(equalTo: taskDescription.topAnchor, constant: -5),
        ])
    }
    
    private func setUpTaskDescriptionLabel(layoutGuide: UILayoutGuide) {
        taskDescription.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        taskDescription.textColor = .label
        taskDescription.translatesAutoresizingMaskIntoConstraints = false
        taskDescription.numberOfLines = 3
        NSLayoutConstraint.activate([
            taskDescription.topAnchor.constraint(equalTo: taskTitle.bottomAnchor, constant: 5),
            taskDescription.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            taskDescription.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            taskDescription.bottomAnchor.constraint(equalTo: taskDeadline.topAnchor, constant: -5),
        ])
    }
    
    private func setUpTaskDeadlineLabel(layoutGuide: UILayoutGuide) {
        taskDeadline.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        taskDeadline.textColor = .label
        taskDeadline.translatesAutoresizingMaskIntoConstraints = false
        taskDeadline.numberOfLines = 1
        NSLayoutConstraint.activate([
            taskDeadline.topAnchor.constraint(equalTo: taskDescription.bottomAnchor, constant: 5),
            taskDeadline.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            taskDeadline.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            taskDeadline.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    func configureCell(with: Task) {
        setUpUI()
        self.contentView.backgroundColor = UIColor.red
        taskTitle.text = with.taskTitle
        taskDescription.text = with.taskDescription
        taskDeadline.text = with.taskDeadline
    }
}

extension TaskCollectionViewCell: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(pan.translation(in: self))
        return (pan.velocity(in: pan.view)).x < (pan.velocity(in: pan.view)).y
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.gray
        
        cellLabel = UILabel()
        cellLabel.textColor = UIColor.white
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellLabel)
        NSLayoutConstraint.activate([
            cellLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            cellLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1/3),
            cellLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            cellLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])

        deleteLabel = UILabel()
        deleteLabel.text = "Delete"
        deleteLabel.textColor = UIColor.white
        self.insertSubview(deleteLabel, belowSubview: self.contentView)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizer.State.changed) {
            let p: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: p.x, y: 0, width: width, height: height)
            self.deleteLabel.frame = CGRect(x: p.x + width + deleteLabel.frame.size.width, y: 0, width: 50, height: height)
        }
        
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {
            
        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
//                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
}
