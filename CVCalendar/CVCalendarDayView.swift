//
//  CVCalendarDayView.swift
//  CVCalendar
//
//  Created by E. Mozharovsky on 12/26/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

class CVCalendarDayView: UIView {
    
    // MARK: - Public properties

    let weekView: CVCalendarWeekView?
    let weekdayIndex: Int?
    let day: Int? 
    
    var dayLabel: UILabel?
    var circleView: CVCircleView?
    
    var isOut = false
    var isCurrentDay = false
    
    // MARK: - Initialization
    
    init(weekView: CVCalendarWeekView, frame: CGRect, weekdayIndex: Int) {
        super.init()
        
        self.weekView = weekView
        self.frame = frame
        self.weekdayIndex = weekdayIndex
        
        func hasDayAtWeekdayIndex(weekdayIndex: Int, weekdaysDictionary: [Int : [Int]]) -> Bool {
            let keys = weekdaysDictionary.keys
            
            for key in keys.array {
                //println("Key: \(key), weekday index:\(weekdayIndex)")
                if key == weekdayIndex {
                    return true
                }
            }
            
            return false
        }
        
        let weekdaysIn = self.weekView!.weekdaysIn!
        if (self.weekView!.index == 0) || (self.weekView!.index == self.weekView!.monthView!.numberOfWeeks! - 1) {
            if let weekdaysOut = self.weekView!.weekdaysOut {
                if hasDayAtWeekdayIndex(self.weekdayIndex!, weekdaysOut) {
                    self.day = weekdaysOut[self.weekdayIndex!]![0]
                    self.isOut = true
                } else {
                    self.day = weekdaysIn[self.weekdayIndex!]![0]
                }
            }
        } else {
            self.day = weekdaysIn[self.weekdayIndex!]![0]
        }
        
        if self.day == self.weekView!.monthView!.currentDay {
            self.isCurrentDay = true
        }
        
        if !self.weekView!.monthView!.calendarView!.shouldShowWeekdaysOut! {
            if !self.isOut {
                self.labelSetup()
                self.topMarkerSetup()
                self.setupGestures()
            } else {
                self.removeFromSuperview()
            }
        } else {
            self.labelSetup()
            self.topMarkerSetup()
            self.setupGestures()
        }

        //self.backgroundColor = UIColor.greenColor()
        println("Day #\(self.day!) in Week #\(self.weekView!.index!) successfully created!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties setup
    
    func labelSetup() {
        let appearance = CVCalendarViewAppearance.sharedCalendarViewAppearance
        
        self.dayLabel = UILabel()
        self.dayLabel!.text = String(self.day!)
        self.dayLabel!.textAlignment = NSTextAlignment.Center
        self.dayLabel!.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        
        var color: UIColor?
        if self.isOut {
            color = appearance.dayLabelWeekdayOutTextColor
        } else if self.isCurrentDay {
            self.weekView!.monthView!.receiveDayViewTouch(self)
        } else {
            color = appearance.dayLabelWeekdayInTextColor
        }
        
        var font = UIFont.systemFontOfSize(appearance.dayLabelWeekdayTextSize!)
        
        if !self.isCurrentDay {
            self.dayLabel!.textColor = color!
            self.dayLabel!.font = font
        }
        
        self.addSubview(self.dayLabel!)
    }
    
    
    func topMarkerSetup() {
        let height = CGFloat(0.5)
        let layer = CALayer()
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = height
        layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), height)
        
        self.layer.addSublayer(layer)
    }
    
    // MARK: - Events handling
    
    func setupGestures() {
        println("Gesture added!")
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dayViewTapped")
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func dayViewTapped() {
        let monthView = self.weekView!.monthView!
        monthView.receiveDayViewTouch(self)
    }
    
    // MARK: - Label states management
    
    func setDayLabelHighlighted() {
        let appearance = CVCalendarViewAppearance.sharedCalendarViewAppearance
        
        var color: UIColor?
        var _alpha: CGFloat?
        
        if self.isCurrentDay {
            color = appearance.dayLabelPresentWeekdayHighlightedBackgroundColor!
            _alpha = appearance.dayLabelPresentWeekdayHighlightedBackgroundAlpha!
            self.dayLabel?.textColor = appearance.dayLabelPresentWeekdayHighlightedTextColor!
            self.dayLabel?.font = UIFont.boldSystemFontOfSize(appearance.dayLabelPresentWeekdayHighlightedTextSize!)
        } else {
            color = appearance.dayLabelWeekdayHighlightedBackgroundColor
            _alpha = appearance.dayLabelWeekdayHighlightedBackgroundAlpha
            self.dayLabel?.textColor = appearance.dayLabelWeekdayHighlightedTextColor
            self.dayLabel?.font = UIFont.boldSystemFontOfSize(appearance.dayLabelWeekdayHighlightedTextSize!)
        }
        
        self.circleView = CVCircleView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height), color: color!, _alpha: _alpha!)
        self.insertSubview(self.circleView!, atIndex: 0)
        
        if self.isOut {
            // TODO: Change the current month
        }
    }
    
    func setDayLabelUnhighlighted() {
        let appearance = CVCalendarViewAppearance.sharedCalendarViewAppearance
        
        var color: UIColor?
        if self.isOut {
            color = appearance.dayLabelWeekdayOutTextColor
        } else if self.isCurrentDay {
            color = appearance.dayLabelPresentWeekdayTextColor
        } else {
            color = appearance.dayLabelWeekdayInTextColor
        }
        
        var font: UIFont?
        if self.isCurrentDay {
            if appearance.dayLabelPresentWeekdayInitallyBold {
                font = UIFont.boldSystemFontOfSize(appearance.dayLabelPresentWeekdayTextSize!)
            } else {
                font = UIFont.systemFontOfSize(appearance.dayLabelPresentWeekdayTextSize!)
            }
        } else {
            font = UIFont.systemFontOfSize(appearance.dayLabelWeekdayTextSize!)
        }
        
        self.dayLabel?.textColor = color
        self.dayLabel?.font = font
        
        self.circleView?.removeFromSuperview()
    }
    
}