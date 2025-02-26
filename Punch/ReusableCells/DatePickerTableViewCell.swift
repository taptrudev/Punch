//
//  DatePickerTableViewCell.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//


import UIKit
import Lottie

protocol DatePickerDelegate: class {
    func didChangeDate(date: Date, indexPath: IndexPath)
}

class DatePickerTableViewCell: UITableViewCell {
    
    // Remove constraint && Reset them depending on if the calendar isOpen or not.

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var animationContainerView: UIView!
    var animationView = AnimationView()
    
    var isOpen = false
    
    var indexPath: IndexPath!
    weak var delegate: DatePickerDelegate?
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "DatePickerTableViewCellIdentifier"
    }
    
    // Nib name
    class func nibName() -> String {
        return "DatePickerTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        heightConstraint.constant = 0
        isOpen = false
        setupAnimationView()
        setCornerRadius()
        selectedBackgroundView?.setCornerRadius()
        datePicker.setDate(Date(), animated: true)
        clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if isOpen {
            toggleCalendar(active: false)
        }
    }
    
    
    func setupAnimationView() {
        // For arrow UP: animationView.currentProgress = 0.5
        // For arrow DOWN: animationView.currentProgress = 0
        animationView = AnimationView(name: "openClose")
        animationView.contentMode = .scaleAspectFill
        animationView.currentProgress = isOpen ? 0.5 : 0.0
        animationContainerView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: animationContainerView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: animationContainerView, attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: animationContainerView, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: animationContainerView, attribute: .height, multiplier: 1.0, constant: 0.0)
            ])
    }
    
    func playAnimationView() {
        animationView.transform = isOpen ? CGAffineTransform.identity : CGAffineTransform(scaleX: 1, y: -1)
        animationView.play(fromProgress: 0.0, toProgress: 0.5, loopMode: .none, completion: nil)
    }
    
    func toggleCalendar(active: Bool) {
        self.heightConstraint.constant = active ? 190 : 0
        self.isOpen = active ? true : false
        self.playAnimationView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initView() {
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }
    
    @objc func dateDidChange(_ sender: UIDatePicker) {
        delegate?.didChangeDate(date: sender.date, indexPath: indexPath)
    }
    
    func updateText(date: Date) {
        dateLabel.text = date.convertToString(dateformat: .dateWithTime)
    }

}
