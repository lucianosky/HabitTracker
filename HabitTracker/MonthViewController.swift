//
//  ViewController.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 04/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController {
    
    var calMonth: CalMonth?
    
    let monthLabel = UILabel(.helveticaBold24, .darkText, "Month")
    let yearLabel = UILabel(.helveticaBold20, .darkText, "Year")
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        createSubviews()
        createConstraints()
//        createBinds()
//        readViewModel()
        calMonth = CalMonth()
        refreshData()
    }
    
    func createSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(WeekTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .background
        
        view.backgroundColor = .background
        view.addSubview(tableView)
        view.addSubview(yearLabel)
        view.addSubview(monthLabel)
        
        // TODO: Rx
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MonthViewController.swipedMonth(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MonthViewController.swipedMonth(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let tapMonth = UITapGestureRecognizer(target: self, action: #selector(MonthViewController.tappedMonth(sender:)))
        monthLabel.isUserInteractionEnabled = true
        monthLabel.addGestureRecognizer(tapMonth)
        yearLabel.addGestureRecognizer(tapMonth)

        let swipeYearLeft = UISwipeGestureRecognizer(target: self, action: #selector(MonthViewController.swipedYear(gesture:)))
        swipeYearLeft.direction = .left
        yearLabel.isUserInteractionEnabled = true
        yearLabel.addGestureRecognizer(swipeYearLeft)
        
        let swipeYearRight = UISwipeGestureRecognizer(target: self, action: #selector(MonthViewController.swipedYear(gesture:)))
        swipeYearRight.direction = .right
        yearLabel.addGestureRecognizer(swipeYearRight)
        
    }
    func createConstraints() {
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

    @objc func swipedMonth(gesture: UISwipeGestureRecognizer) {
        // TODO optional
        let date = gesture.direction == .left ? calMonth!.prevMonth() : calMonth!.nextMonth()
        browseMonth(date: date)
    }

    @objc func swipedYear(gesture: UISwipeGestureRecognizer) {
        // TODO optional
        let date = gesture.direction == .left ? calMonth!.prevYear() : calMonth!.nextYear()
        browseMonth(date: date)
    }
    
    @objc func tappedMonth(sender: UITapGestureRecognizer) {
        browseMonth(date: Date())
    }
    
    private func browseMonth(date: Date) {
        calMonth = CalMonth(date: date)
        tableView.reloadData()
        refreshData()
    }
    
    private func refreshData() {
        monthLabel.text = calMonth?.monthName()
        yearLabel.text = calMonth?.year()
    }
    
}


extension MonthViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : calMonth?.weeks ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeekTableViewCell
        if indexPath.section == 0 {
            let headers = CalMonth.getWeekHeaders()
            for tag in 0...6 {
                if let dayView = cell.viewWithTag(tag+1) as? DayView {
                    dayView.text = headers[tag]
                    dayView.dayState = .inactive
                }
            }
        } else {
            if let days = calMonth?.getWeekDays(indexPath.row) {
                for tag in 0...6 {
                    if let dayView = cell.viewWithTag(tag+1) as? DayView {
                        dayView.text = "\(days[tag].day)"
                        dayView.dayState = days[tag].fromMonth ? .none : .inactive
                    }
                }
            }
        }
        return cell
    }
    
}

extension MonthViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension UILabel {
    
    convenience init(_ sfont: SFont, _ color: UIColor, _ text: String = "", _ tag: Int = 0) {
        self.init()
        self.text = text
        self.font = sfont.font
        self.textColor = color
        self.tag = tag
        accessibilityIdentifier = text
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

