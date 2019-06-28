//
//  AddShiftViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-27.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class AddShiftViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var datePickerIndexPath: IndexPath?
    
    var dataSource: [[(String, Any)]] = [
        [(title: "Start Date", date: Date())],
        [(title: "End Date", date: Date())],
        [(title: "Employee", employees: [
            Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
            Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
            Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
            Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
            ])]
        
    ]
    var selectedRowSection = -1 // only one selected cell allowed.
    var cellIsSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.setGradientBackground(colorOne: CustomColors.orange, colorTwo: CustomColors.darkOrange)
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: DatePickerTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: EmployeeTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: EmployeeTableViewCell.reuseIdentifier())
    }

}

// MARK: UITABLEVIEW DATASOURCE

extension AddShiftViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Start Date"
        case 1:
            return "End Date"
        case 2:
            return "Employee"
        case 3:
            return "Save Shift"
        default:
            break
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? dataSource[2].count : 1 // Only need 1 row except for employees section.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0,1:
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier:   DatePickerTableViewCell.reuseIdentifier()) as!  DatePickerTableViewCell
            datePickerCell.delegate = self
            datePickerCell.indexPath = indexPath
            datePickerCell.updateText(text: dataSource[indexPath.section][indexPath.row].0, date: dataSource[indexPath.section][indexPath.row].1 as! Date)
            return datePickerCell
        case 2:
            let employeeCell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.reuseIdentifier()) as! EmployeeTableViewCell
            employeeCell.titleLabel.text = dataSource[indexPath.section][indexPath.row].0
            return employeeCell
        default:
            break // Confirm Button Cell.
        }
        
        return UITableViewCell()
    }
    
    
}

// MARK: UITABLEVIEW DELEGATE

extension AddShiftViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == selectedRowSection {
            // Index path must be less than 2 to cast as DatePickerTableViewCell
            let cell = tableView.cellForRow(at: indexPath) as! DatePickerTableViewCell
            if !cell.isOpen {
                cell.toggleCalendar(active: true)
            }
            return 280
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? DatePickerTableViewCell {
            if cell.isOpen {
                cell.toggleCalendar(active: false)
            }
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0,1:
            // DATE PICKERS
            if selectedRowSection != indexPath.section {
                cellIsSelected = true
                selectedRowSection = indexPath.section
                
            } else {
                cellIsSelected = false
                selectedRowSection = -1
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        case 2:
            // EMPLOYEES
            if let cell = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell {
                cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
                selectedRowSection = -1 // Hide the date pickers if open.
            }
        default:
            // SAVE BUTTON
            break // Button to save dismiss vc and
        }
        
    }
}

extension AddShiftViewController: DatePickerDelegate {
    
    func didChangeDate(date: Date, indexPath: IndexPath) {
        dataSource[indexPath.section][indexPath.row].1 = date
        let cell = tableView.cellForRow(at: indexPath) as! DatePickerTableViewCell
        cell.updateText(text: dataSource[indexPath.section][indexPath.row].0, date: dataSource[indexPath.section][indexPath.row].1 as! Date)
    }
    
}
