//
//  ViewController.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 04/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

private struct Constants {
    static let tableCellId = "weekCell"
}

class MonthViewController: UIViewController {
    
    var viewModel: MonthViewModel
    private let disposeBag = DisposeBag()

    let monthLabel = UILabel(.helveticaBold24, .darkText, "")
    let yearLabel = UILabel(.helveticaBold20, .darkText, "")
    let tableView = UITableView()
    
    init(viewModel: MonthViewModel? = nil) {
        self.viewModel = viewModel ?? MonthViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#file) \(#function) not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSubviews()
        createConstraints()
        createDataBinds()
        createGestureBinds()
        viewModel.serviceCall()
    }
    
    private func createSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(WeekTableViewCell.self, forCellReuseIdentifier: Constants.tableCellId)
        tableView.backgroundColor = .background
        tableView.isScrollEnabled = false
        
        view.backgroundColor = .background
        view.addSubview(tableView)
        view.addSubview(yearLabel)
        view.addSubview(monthLabel)
    }
    
    private func createConstraints() {
        let viewsDict: [String: Any] = [
            "tableView": tableView,
            "monthLabel": monthLabel,
            "yearLabel": yearLabel,
            "topGuide": self.topLayoutGuide,
            // TODO: warning above
            // http://germanylandofinnovation.com/questions/29066/swift-safe-area-layout-guide-und-visual-format-language
        ]
        
        activateConstraints("V:[topGuide]-40-[monthLabel]-5-[yearLabel]-20-[tableView]-|", views: viewsDict)
        activateConstraints("H:|-[tableView]-|", views: viewsDict)
        activateConstraints("H:|-30-[monthLabel]", views: viewsDict)
        yearLabel.equalConstraints([.left], to: monthLabel)
    }

    private func createDataBinds() {
        tableView.rx.base.delegate = self

        viewModel.dataSource
            .bind(to: tableView.rx.items){ [weak self] (tableView, row, calWeek) in
                if let self = self, let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellId, for: IndexPath(row: row, section: 0)) as? WeekTableViewCell {
                    
//                    for tag in 0...6 {
//                        if let dayView = cell.viewWithTag(tag+1) as? DayView {
//
//                            let calDay = calWeek.days[tag]
//                            dayView.text = calDay.text
//                            dayView.active = calDay.fromMonth
//                            if let date = calDay.date, calDay.fromMonth {
//                                dayView.habitState = self.viewModel.getHabitState(date: date)
//                            } else {
//                                dayView.habitState = .none
//                            }
//                            dayView.date = calWeek.days[tag].date
//
//                            dayView.rx
//                                .tapGesture()
//                                .when(.recognized)
//                                .subscribe(onNext: { _ in
//                                    // TODO log if null
//                                    if let date = dayView.date {
//                                        let (result, newState) = self.setHabitState(date: date)
//                                        if result {
//                                            dayView.habitState = newState
//                                        }
//                                    }
//                                })
//                                .disposed(by: self.disposeBag)
//                        }
//                    }
//                    return cell
                    
                    return cell.configure(from: calWeek, monthViewController: self)
                }
                return UITableViewCell()
            }
            .disposed(by: disposeBag)
        
        viewModel.currentDate
            .subscribe(onNext: { [weak self] (date) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "LLLL"
                self?.monthLabel.text = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "YYYY"
                self?.yearLabel.text = dateFormatter.string(from: date)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func createGestureBinds() {
        monthLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.browseToday()
            })
            .disposed(by: self.disposeBag)

        yearLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.browseToday()
            })
            .disposed(by: self.disposeBag)
        
        yearLabel.rx
            .swipeGesture([.left, .right])
            .when(.recognized)
            .subscribe(onNext: { [weak self] gesture in
                self?.viewModel.browse(bySwipping: .year, toNext: gesture.direction == .left)
            })
            .disposed(by: self.disposeBag)
        
        view.rx
            .swipeGesture([.left, .right])
            .when(.recognized)
            .subscribe(onNext: { [weak self] gesture in
                self?.viewModel.browse(bySwipping: .month, toNext: gesture.direction == .left)
            })
            .disposed(by: disposeBag)
    }
    
    func setHabitState(date: Date) -> (Bool, HabitState) {
        return viewModel.setHabitState(date: date)
    }
    
}

extension MonthViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

