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
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calMonth = CalMonth()
        refreshData()
        tableView.rowHeight = 50
        tableView.register(WeekTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func prevMonthTouched(_ sender: Any) {
        // TODO optional
        calMonth = CalMonth(date: calMonth!.prevMonth())
        tableView.reloadData()
        refreshData()
    }
    
    @IBAction func nextMonthTouched(_ sender: Any) {
        // TODO optional
        calMonth = CalMonth(date: calMonth!.nextMonth())
        tableView.reloadData()
        refreshData()
    }
    
    func refreshData() {
        monthLabel.text = calMonth?.monthName()
        yearLabel.text = calMonth?.year()
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
                if let button = cell.viewWithTag(tag+1) as? UIButton {
                    button.setTitle("\(headers[tag])", for: .normal)
                    button.setTitleColor(UIColor.gray, for: .normal)
                    button.isEnabled = false
                    button.isSelected = false
                }
            }
        } else {
            if let days = calMonth?.getWeekDays(indexPath.row) {
                for tag in 0...6 {
                    if let button = cell.viewWithTag(tag+1) as? UIButton {
                        let color = days[tag].fromMonth ? UIColor.black : UIColor.gray
                        button.isSelected = false
                        button.setTitle("\(days[tag].day)", for: .normal)
                        button.setTitleColor(color, for: .normal)
                        button.isEnabled = days[tag].fromMonth
                        if days[tag].fromMonth {
                            button.addTarget(self, action: #selector(MonthViewController.buttonClicked(_:)), for: .touchUpInside)
                        }
                    }
                }
            }
        }
        return cell
    }
    
}
