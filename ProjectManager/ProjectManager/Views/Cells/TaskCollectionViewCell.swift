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
    var panGestureRecognizer: UIPanGestureRecognizer!
    var swipeView = UIView()
    var estimatedSize: CGSize = CGSize(width: 0, height: 0)
    var deleteButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpUI() {
        self.contentView.backgroundColor = UIColor.red
        let swipeViewSafeArea = self.swipeView.safeAreaLayoutGuide
        let contentViewSafeArea = self.contentView.safeAreaLayoutGuide
        self.addSubviewInContentView()
        self.setUpSwipeView(layoutGuide: contentViewSafeArea)
        self.setUpDeleteButton(layoutGuide: contentViewSafeArea)
        self.setUpTaskTitleLabel(layoutGuide: swipeViewSafeArea)
        self.setUpTaskDescriptionLabel(layoutGuide: swipeViewSafeArea)
        self.setUpTaskDeadlineLabel(layoutGuide: swipeViewSafeArea)
    }
    
    private func addSubviewInContentView() {
        self.contentView.addSubview(self.swipeView)
        self.contentView.addSubview(self.deleteButton)
    }
    
    private func setUpSwipeView(layoutGuide: UILayoutGuide) {
//        self.swipeView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 500)
        self.swipeView.backgroundColor = .white
        self.swipeView.addSubview(self.taskTitle)
        self.swipeView.addSubview(self.taskDescription)
        self.swipeView.addSubview(self.taskDeadline)
        self.swipeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.swipeView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 0),
            self.swipeView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 0),
            self.swipeView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: 0),
            self.swipeView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    private func setUpDeleteButton(layoutGuide: UILayoutGuide) {
//        self.deleteButton.frame = CGRect(x: self.contentView.frame.width, y: 0, width: 150, height: self.contentView.frame.height)
        self.deleteButton.setTitle("Delete", for: .normal)
        self.deleteButton.setTitleColor(.blue, for: .normal)
        self.deleteButton.backgroundColor = .yellow
        self.deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchDown)
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.deleteButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 0),
            self.deleteButton.leadingAnchor.constraint(equalTo: self.swipeView.trailingAnchor, constant: 0),
//            self.deleteButton.widthAnchor.constraint(equalTo: nil , constant: 150),
            self.deleteButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    private func setUpTaskTitleLabel(layoutGuide: UILayoutGuide) {
        self.taskTitle.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        self.taskTitle.textColor = .label
        self.taskTitle.translatesAutoresizingMaskIntoConstraints = false
        self.taskTitle.numberOfLines = 1
        NSLayoutConstraint.activate([
            self.taskTitle.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 5),
            self.taskTitle.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            self.taskTitle.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            self.taskTitle.bottomAnchor.constraint(equalTo: self.taskDescription.topAnchor, constant: -5),
        ])
    }
    
    private func setUpTaskDescriptionLabel(layoutGuide: UILayoutGuide) {
        self.taskDescription.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        self.taskDescription.textColor = .label
        self.taskDescription.translatesAutoresizingMaskIntoConstraints = false
        self.taskDescription.numberOfLines = 3
        NSLayoutConstraint.activate([
            self.taskDescription.topAnchor.constraint(equalTo: self.taskTitle.bottomAnchor, constant: 5),
            self.taskDescription.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            self.taskDescription.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            self.taskDescription.bottomAnchor.constraint(equalTo: self.taskDeadline.topAnchor, constant: -5),
        ])
    }
    
    private func setUpTaskDeadlineLabel(layoutGuide: UILayoutGuide) {
        self.taskDeadline.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        self.taskDeadline.textColor = .label
        self.taskDeadline.translatesAutoresizingMaskIntoConstraints = false
        self.taskDeadline.numberOfLines = 1
        NSLayoutConstraint.activate([
            self.taskDeadline.topAnchor.constraint(equalTo: self.taskDescription.bottomAnchor, constant: 5),
            self.taskDeadline.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            self.taskDeadline.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            self.taskDeadline.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    func configureCell(with: Task) {
        self.taskTitle.text = with.taskTitle
        self.taskDescription.text = with.taskDescription
        self.taskDeadline.text = with.taskDeadline
        self.swipeView.layoutIfNeeded()
        self.estimatedSize = self.swipeView.systemLayoutSizeFitting(sizeThatFits(CGSize(width: self.contentView.frame.width, height: 500.0)))
        self.swipeView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.estimatedSize.height)
    }
    
    func getEstimatedHeight() -> CGFloat {
        return self.estimatedSize.height
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
        if self.swipeView.center.x < self.frame.width/2 && (panGestureRecognizer.velocity(in: panGestureRecognizer.view)).x > 0 {
            return true
        }
        return false
    }
    
    private func commonInit() {
        self.setUpUI()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func deleteTask() {
        let collectionView: UICollectionView = self.superview as! UICollectionView
        let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
        print("collectionView: ", collectionView)
        print("indexPath: ", indexPath)
//        collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        self.swipeView.translatesAutoresizingMaskIntoConstraints = true
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = true
        let transition = pan.translation(in: self.swipeView)
        var changedX = self.swipeView.center.x + transition.x
        
        if self.swipeView.center.x < self.frame.width/2 - 150 {
            changedX = self.frame.width/2 - 150
        }
        if self.swipeView.center.x > self.frame.width/2 {
            changedX = self.frame.width/2
        }
        UIView.animate(withDuration: 0.2) {
            self.deleteButton.frame = CGRect(x: changedX + self.contentView.frame.width/2, y: 0, width: 150, height: self.contentView.frame.height)
            self.panGestureRecognizer.setTranslation(CGPoint.zero, in: self.deleteButton)
            self.swipeView.center = CGPoint(x: changedX, y: self.swipeView.center.y)
            self.panGestureRecognizer.setTranslation(CGPoint.zero, in: self.swipeView)
        }
        
        if pan.state == UIGestureRecognizer.State.ended {
            if self.swipeView.center.x + 150/2 < contentView.center.x {
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.swipeView.frame = CGRect(x: -(self?.deleteButton.frame.width)!, y: 0, width: (self?.contentView.frame.width)!, height: (self?.contentView.frame.height)!)
                    self?.deleteButton.frame = CGRect(x: (self?.contentView.frame.width)!-150, y: 0, width: 150, height: (self?.contentView.frame.height)!)
                }
                return
            }
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.swipeView.frame = CGRect(x: 0, y: 0, width: (self?.contentView.frame.width)!, height: (self?.contentView.frame.height)!)
                self?.deleteButton.frame = CGRect(x: (self?.contentView.frame.width)!, y: 0, width: 150, height: (self?.contentView.frame.height)!)
            }
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



