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
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    // TODO log if null
                    if let date = dayView.date {
                        let (result, newState) = self.monthViewController?.dayTouched(date: date) ?? (false, .none)
                        if result {
                            print(HabitTrackModel.shared.temporaryFuncGetDict())
                            // TODO merge DayState & HabitState
                            switch newState {
                            case .none: dayView.dayState = .none
                            case .done: dayView.dayState = .done
                            case .notDone: dayView.dayState = .notDone
                            }
                            //
                        }
                    }
//                    switch dayView.dayState {
//                    case .inactive: break
//                    case .none: dayView.dayState = .done
//                    case .done: dayView.dayState = .notDone
//                    case .notDone: dayView.dayState = .none
//                    }
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

// TODO review
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        disposeBag = DisposeBag()
//    }
    
    func configure(from calWeek: CalWeek, monthViewController: MonthViewController) -> WeekTableViewCell {
        self.monthViewController = monthViewController
        for tag in 0...6 {
            if let dayView = viewWithTag(tag+1) as? DayView {
                let calDay = calWeek.days[tag]
                dayView.text = calDay.text
                if let date = calDay.date, calDay.fromMonth {
                    // TODO merge states
                    let habitState = monthViewController.viewModel.dayState(date: date)
                    switch habitState {
                    case .none: dayView.dayState = .none
                    case .done: dayView.dayState = .done
                    case .notDone: dayView.dayState = .notDone
                    }
                    
                } else {
                    dayView.dayState = .none
                }
//                dayView.dayState = calWeek.days[tag].fromMonth ? .none : self.monthViewController?.viewModel.dayState(date: calWeek.days[tag].date)
                dayView.date = calWeek.days[tag].date
            }
        }
        return self
    }
    
}



