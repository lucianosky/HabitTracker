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


private struct Constants {
    static let tableCellId = "weekCell"
}

class MonthViewController: UIViewController {
    
    var viewModel: MonthViewModel
    var calMonth: CalMonth?
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
        createGestures()
        createBinds()
        viewModel.serviceCall()
        refreshData()
    }
    
    private func createSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.dataSource = self
//        tableView.delegate = self
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
        
        // TODO - equal aligments H: monthLabel, yearLabel

        //        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topGuide]-40-[prevButton]", options: [], metrics: nil, views: viewsDict))
        //        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topGuide]-40-[nextButton]", options: [], metrics: nil, views: viewsDict))
        //        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[monthLabel]->=20-[prevButton]-8-[nextButton]-40-|", options: [], metrics: nil, views: viewsDict))

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topGuide]-40-[monthLabel]-5-[yearLabel]-20-[tableView]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tableView]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[monthLabel]", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[yearLabel]-|", options: [], metrics: nil, views: viewsDict))
    }

    private func createGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MonthViewController.swipedMonth(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MonthViewController.swipedMonth(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let tapMonth = UITapGestureRecognizer(target: self, action: #selector(MonthViewController.tappedToday(sender:)))
        monthLabel.isUserInteractionEnabled = true
        monthLabel.addGestureRecognizer(tapMonth)
        
        let tapYear = UITapGestureRecognizer(target: self, action: #selector(MonthViewController.tappedToday(sender:)))
        yearLabel.isUserInteractionEnabled = true
        yearLabel.addGestureRecognizer(tapYear)
        
        let swipeYearLeft = UISwipeGestureRecognizer(target: self, action: #selector(MonthViewController.swipedYear(gesture:)))
        swipeYearLeft.direction = .left
        yearLabel.addGestureRecognizer(swipeYearLeft)
        
        let swipeYearRight = UISwipeGestureRecognizer(target: self, action: #selector(MonthViewController.swipedYear(gesture:)))
        swipeYearRight.direction = .right
        yearLabel.addGestureRecognizer(swipeYearRight)
    }
    
    private func createBinds() {
        tableView.rx.base.delegate = self
        viewModel.dataSource
            .bind(to: tableView.rx.items){ (tableView, row, calWeek) in
                if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellId, for: IndexPath(row: row, section: 0)) as? WeekTableViewCell {
                    return cell.configure(from: calWeek)
                }
                return UITableViewCell()
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func swipedMonth(gesture: UISwipeGestureRecognizer) {
        let value = gesture.direction == .left ? 1 : -1
        // TODO optional
        browseMonth(date: calMonth!.addComponent(component: .month, value: value))
    }

    @objc private func swipedYear(gesture: UISwipeGestureRecognizer) {
        let value = gesture.direction == .left ? 1 : -1
        // TODO optional
        browseMonth(date: calMonth!.addComponent(component: .year, value: value))
    }
    
    @objc func tappedToday(sender: UITapGestureRecognizer) {
        browseMonth(date: Date())
    }
    
    private func browseMonth(date: Date) {
        calMonth = CalMonth(date: date, startOfWeek: calMonth?.startOfWeek ?? viewModel.defaultStartOfWeek)
        tableView.reloadData()
        refreshData()
    }
    
    private func refreshData() {
        monthLabel.text = calMonth?.monthName()
        yearLabel.text = calMonth?.year()
    }
    
}

extension MonthViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

