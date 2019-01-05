//
//  ViewController.swift
//  HabitTracker
//
//  Created by Luciano Sclovsky on 04/01/19.
//  Copyright © 2019 Luciano Sclovsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var calMonth: CalMonth?

    override func viewDidLoad() {
        super.viewDidLoad()
        calMonth = CalMonth()
    }

}


extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calMonth?.weeks ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekCell", for: indexPath)
        if let days = calMonth?.getWeekDays(indexPath.row) {
            for tag in 0...6 {
                if let button = cell.viewWithTag(tag+1) as? UIButton {
                    button.setTitle("\(days[tag].day)", for: .normal)
                    let color = days[tag].fromMonth ? UIColor.black : UIColor.gray
                    button.setTitleColor(color, for: .normal)
                }
            }
        }
        return cell
    }
    
}
