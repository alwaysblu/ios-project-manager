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
    var panGestureRecognizer: UIPanGestureRecognizer!
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
        
        if (panGestureRecognizer.velocity(in: panGestureRecognizer.view)).x < 0 {
            return true
        }
        if self.center.x < self.frame.width/2 && (panGestureRecognizer.velocity(in: panGestureRecognizer.view)).x > 0 {
            return true
        }
        
        return false
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.blue
        deleteLabel = UILabel()
        deleteLabel.text = "Delete"
        deleteLabel.textColor = UIColor.white
        self.insertSubview(deleteLabel, belowSubview: self.contentView)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (panGestureRecognizer.state == UIGestureRecognizer.State.changed) {
            let cellLocation: CGPoint = panGestureRecognizer.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.deleteLabel.frame = CGRect(x: cellLocation.x + width + deleteLabel.frame.size.width, y: 0, width: 50, height: height)
        }
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        
        let transition = pan.translation(in: self)
        var changedX = self.center.x + transition.x
        
        if self.center.x < self.frame.width/2 - 150 {
            changedX = self.frame.width/2 - 150
        }
        if self.center.x > self.frame.width/2 {
            changedX = self.frame.width/2
        }
        UIView.animate(withDuration: 0.2) {
            self.center = CGPoint(x: changedX, y: self.center.y)
            
            self.panGestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
        
//        if pan.state == UIGestureRecognizer.State.began {
//
//        } else if pan.state == UIGestureRecognizer.State.changed {
//            self.setNeedsLayout()
//        } else {
//            if abs(pan.velocity(in: self).x) > 500 {
//                let collectionView: UICollectionView = self.superview as! UICollectionView
//                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
////                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
//            } else {
//                UIView.animate(withDuration: 0.1, animations: {
//                    self.setNeedsLayout()
//                    self.layoutIfNeeded()
//                })
//            }
//        }
    }
}


