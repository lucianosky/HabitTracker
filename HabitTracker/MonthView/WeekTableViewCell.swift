//
//  WeekTableViewCell.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 07/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class WeekTableViewCell: UITableViewCell {
    
    let stack = UIStackView(.horizontal)
    var dayViews = [DayView]()
    weak var monthViewController: MonthViewController?
    
    private var disposeBag = DisposeBag()

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#file) \(#function) not implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for i in 0...6 {
            let dayView = DayView()
            dayView.text = "\(i)"
            dayView.tag = i+1

            dayView.rx
                .longPressGesture()
                .when(.began, .ended)
                .subscribe(onNext: { [weak self] gesture in
                    // TODO log if null
                    if gesture.state == .began {
                        dayView.shrink = true
                    } else {
                        dayView.shrink = false
                        if dayView.isHeader {
                            self?.monthViewController?.changeStartOfWeek(tag: dayView.tag)
                        } else {
                            if let date = dayView.date {
                                self?.monthViewController?.changeHabitState(date: date)
                            }
                        }
                    }
                })
                .disposed(by: self.disposeBag)

            stack.addArrangedSubview(dayView)
            dayViews.append(dayView)
        }
        contentView.addSubview(stack)
        contentView.backgroundColor = .background
        
        let viewsDict = [
            "stack" : stack,
        ]
        
        contentView.activateConstraints("V:|[stack]|", views: viewsDict)
        contentView.activateConstraints("H:|[stack]|", views: viewsDict)
    }

//     TODO: review
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        disposeBag = DisposeBag()
//    }
    
    func configure(from calWeek: CalWeek, monthViewController: MonthViewController) -> WeekTableViewCell {
        
        // XXX
//        if calWeek.isHeader {
//            backgroundColor = .backgroundXXX
//        }
        
        self.monthViewController = monthViewController
        for tag in 0...6 {
            if let dayView = viewWithTag(tag+1) as? DayView {
                let calDay = calWeek.days[tag]
                dayView.text = calDay.text
                dayView.active = calDay.fromMonth
                if let date = calDay.date, calDay.fromMonth {
                    dayView.habitState = monthViewController.viewModel.getHabitState(date: date)
                } else {
                    dayView.habitState = .none
                }
                dayView.date = calWeek.days[tag].date
                dayView.isHeader = calWeek.isHeader
            }
        }
        return self
    }
    
    func changeState(date: Date, habitState: HabitState) -> Bool {
        for dayView in dayViews {
            if dayView.active, let dayDate = dayView.date, dayDate == date {
                dayView.habitState = habitState
                return true
            }
        }
        return false
    }
    
}



