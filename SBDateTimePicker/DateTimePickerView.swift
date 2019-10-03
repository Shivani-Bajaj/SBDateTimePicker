//
//  DateTimePickerView.swift
//  Hoopit
//
//  Created by Shivani.Bajaj on 12/03/19.
//  Copyright © 2019 Hoopit. All rights reserved.
//

import UIKit

protocol DateTimePickerViewDelegate: class {
    func selected(date: Date, withIndexPath indexObj: IndexPath?, withSecondsDuration delta: TimeInterval?)
}

protocol XibRemovalFromSuperviewDelegate: class {
    func removedFromSuperView()
}

@IBDesignable
class DateTimePickerView: UIView {

    // MARK:- Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var datePickerObj: UIDatePicker!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTextToShow: UILabel!
    @IBOutlet weak var viewWithPicker: UIView!
    
    // MARK:- Structures
    
    struct FontSize {
        static let tiny: CGFloat = 12
        static let small: CGFloat = 14
        static let medium: CGFloat = 16
        static let large: CGFloat = 18
    }
    
    // MARK:- Variables
    
    var indexObj:IndexPath?
    var currentPickerMode = UIDatePicker.Mode.dateAndTime
    var maxCountDownInterval: TimeInterval?
    var countDownInterval: TimeInterval? {
        didSet {
            setCountDown()
        }
    }
    
    private var headerFontToUse: UIFont = UIFont.systemFont(ofSize: FontSize.small) {
        didSet {
            lblTextToShow.font = headerFontToUse
        }
    }
    private var doneButtonFontToUse: UIFont = UIFont.systemFont(ofSize: FontSize.small) {
        didSet {
            btnDone.titleLabel?.font = doneButtonFontToUse
        }
    }
    private var doneTitleToSet: String = "Done" {
        didSet {
            btnDone.setTitle(doneTitleToSet, for: .normal)
        }
    }
    private var headerTextToSet: String? {
        didSet {
            lblTextToShow.text = headerTextToSet
        }
    }
    
    // MARK: Inspectable Variables
    
    @IBInspectable
    var headerFont: UIFont {
        get {
            return headerFontToUse
        }
        set {
            headerFontToUse = newValue
        }
    }
    
    @IBInspectable
    var doneButtonFont: UIFont {
        get {
            return headerFontToUse
        }
        set {
            headerFontToUse = newValue
        }
    }
    
    @IBInspectable
    var doneTitle: String {
        get {
            return doneTitleToSet
        }
        set {
            doneTitleToSet = newValue
        }
    }
    
    @IBInspectable
    var headerText: String? {
        get {
            return headerTextToSet
        }
        set {
            headerTextToSet = newValue
        }
    }
    
    @IBInspectable
    var pickerMode: Int {
        get {
            return currentPickerMode.rawValue
        }
        set {
            currentPickerMode = UIDatePicker.Mode(rawValue: newValue) ?? UIDatePicker.Mode.dateAndTime
        }
    }
    
    // MARK: - Variables Received
    
    weak var delegate: DateTimePickerViewDelegate?
    weak var removalDelegate: XibRemovalFromSuperviewDelegate?
    
    //MARK:- Initialization Methods
    
    init(frame: CGRect,
         withDatePickerMode datePickerMode: UIDatePicker.Mode,
         withMinimumDate minimumDate: Date? = nil,
         withMaximumDate maximumDate: Date? = nil,
         withHeaderText textToShow: String? = nil,
         withMinuteInterval minuteInterval: Int? = nil,
         withDateToSet dateObj: Date? = nil,
         withCountDownInterval countDown: TimeInterval? = nil,
         withIndexPath indexObj: IndexPath? = nil,
         withMaxCountDownInterval maxCountDownInterval: TimeInterval? = nil) {
        
        super.init(frame: frame)
        currentPickerMode = datePickerMode
        self.indexObj = indexObj
        countDownInterval = countDown
        datePickerObj.datePickerMode = datePickerMode
        datePickerObj.minimumDate = minimumDate
        datePickerObj.maximumDate = maximumDate
        datePickerObj.minuteInterval = minuteInterval ?? 1
        self.maxCountDownInterval = maxCountDownInterval
        if let dateObj = dateObj {
            datePickerObj.date = dateObj
        }
        headerText = textToShow
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK:- Setup Methods
    
    private func setup() {
        Bundle.main.loadNibNamed("DateTimePickerView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,UIView.AutoresizingMask.flexibleHeight]
        btnDone.addTarget(self, action: #selector(done), for: .touchUpInside)
        datePickerObj.addTarget(self, action: #selector(pickerValueChanged), for: .valueChanged)
        let tapGestureObj = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureObj.delegate = self
        self.addGestureRecognizer(tapGestureObj)
        setCountDown()
    }
    
    private func removeView() {
        removalDelegate?.removedFromSuperView()
        self.removeFromSuperview()
    }
    
    // MARK: Methods
    
    func set(pickerMode: UIDatePicker.Mode) {
        currentPickerMode = pickerMode
    }
    
    func set(font: UIFont) {
        headerFontToUse = font
        doneButtonFontToUse = font
    }
    
    private func setCountDown() {
        if datePickerObj.datePickerMode == .countDownTimer {
            var dateComp = DateComponents()
            dateComp.hour = 0
            if let countDown = countDownInterval {
                dateComp.minute = Int(countDown) / 60
            } else {
                dateComp.minute = datePickerObj.minuteInterval
            }
            if let date = Calendar.current.date(from: dateComp) {
                datePickerObj.setDate(date, animated: true)
            }
        }
    }
    
    //MARK:- Target Methods
    
    @objc func done() {
        if currentPickerMode == UIDatePicker.Mode.countDownTimer {
            delegate?.selected(date: datePickerObj.date, withIndexPath: indexObj, withSecondsDuration: datePickerObj.countDownDuration)
        } else {
            delegate?.selected(date: datePickerObj.date, withIndexPath: indexObj, withSecondsDuration: nil)
        }
        
        self.removeView()
    }
    
    @objc private func viewTapped() {
        self.removeView()
    }
    
    @objc private func pickerValueChanged() {
        if currentPickerMode == UIDatePicker.Mode.countDownTimer {
            if let maxCountDownInterval = maxCountDownInterval {
                if datePickerObj.countDownDuration > maxCountDownInterval {
                    UIView.animate(withDuration: 0.2) {
                        self.datePickerObj.countDownDuration = maxCountDownInterval
                        self.layoutIfNeeded()
                    }
                }
            }
        }
    }
}

//MARK:- Gesture delegate Methods

extension DateTimePickerView:UIGestureRecognizerDelegate {
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view,touchedView == viewWithPicker {
            return false
        }
        return true
    }
}
