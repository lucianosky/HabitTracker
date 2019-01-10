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
//    var calMonth: CalMonth?
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
        
        // TODO - equal aligments H: monthLabel, yearLabel
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
        
        viewModel.currentDate.subscribe(onNext: { [weak self] (date) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            self?.monthLabel.text = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "YYYY"
            self?.yearLabel.text = dateFormatter.string(from: date)
        })
        .disposed(by: self.disposeBag)
    }
    
    @objc private func swipedMonth(gesture: UISwipeGestureRecognizer) {
        viewModel.browse(bySwipping: .month, toNext: gesture.direction == .left)
    }

    @objc private func swipedYear(gesture: UISwipeGestureRecognizer) {
        viewModel.browse(bySwipping: .year, toNext: gesture.direction == .left)
    }
    
    @objc func tappedToday(sender: UITapGestureRecognizer) {
        viewModel.browseToday()
    }
    
}

extension MonthViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

