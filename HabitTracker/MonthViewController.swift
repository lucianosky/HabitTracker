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
    
    let monthLabel = UILabel(.helveticaBold24, .doneDark, "Month")
    let yearLabel = UILabel(.helveticaBold20, .doneDark, "Year")
    let tableView = UITableView()
    let prevButton = UIButton(.helveticaBold20, .doneDark, "<")
    let nextButton = UIButton(.helveticaBold20, .doneDark, ">")

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
        
        prevButton.addTarget(self, action: #selector(MonthViewController.prevMonthTouched(_:)), for: .touchUpInside)
        view.addSubview(prevButton)
        nextButton.addTarget(self, action: #selector(MonthViewController.nextMonthTouched(_:)), for: .touchUpInside)
        view.addSubview(nextButton)

    }
    
    func createConstraints() {
        let viewsDict: [String: Any] = [
            "tableView": tableView,
            "monthLabel": monthLabel,
            "yearLabel": yearLabel,
            "prevButton": prevButton,
            "nextButton": nextButton,
            "topGuide": self.topLayoutGuide,
            // TODO: warning above
            // http://germanylandofinnovation.com/questions/29066/swift-safe-area-layout-guide-und-visual-format-language
        ]
        
        // TODO - equal alingments V: monthLabel, nextButton, prevButton
        // TODO - equal aligments H: monthLabel, , yearLabel
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topGuide]-40-[monthLabel]-5-[yearLabel]-20-[tableView]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topGuide]-40-[prevButton]", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topGuide]-40-[nextButton]", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tableView]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[monthLabel]->=20-[prevButton]-8-[nextButton]-40-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[yearLabel]-|", options: [], metrics: nil, views: viewsDict))
    }

    @objc func prevMonthTouched(_ sender: Any) {
        // TODO optional
        calMonth = CalMonth(date: calMonth!.prevMonth())
        tableView.reloadData()
        refreshData()
    }
    
    @objc func nextMonthTouched(_ sender: Any) {
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

extension MonthViewController : UITableViewDelegate {
    
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

