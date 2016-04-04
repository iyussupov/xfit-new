//
//  CalendarWeekViewController.swift
//

import UIKit

protocol CalendarWeekViewControllerDelegate {
    func nextWeekView()
    func prevWeekView()
    func afterAutoScroll()
    func daySelect()
    func toNextDay()
    func toPrevDay()
    func tapOnDay()
}

class CalendarWeekViewControllerView: UIView, UIScrollViewDelegate, CalendarWeekViewDelegate {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    var delegate:CalendarWeekViewControllerDelegate?
    var prevWeek: [GDate] = [GDate]()
    var presentWeek: [GDate] = [GDate]()
    var nextWeek: [GDate] = [GDate]()
    var scrollView: UIScrollView?
    
    var presentWeekView: CalendarWeekView?
    var prevWeekView: CalendarWeekView?
    var nextWeekView: CalendarWeekView?
    
    var prevWeekDay: GDate = GDate()
    var presentWeekDay: GDate = GDate()
    var nextWeekDay: GDate = GDate()
    
    var selectedDay: GDate = GDate()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initContentView()
        getPresentWeek()
        initWeekView()
        presentWeekView?.selectDayFromWeek(selectedDay)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initContentView() {
        scrollView = UIScrollView(frame: CGRectMake(0, 0, frame.width, frame.height))
        scrollView!.contentSize = CGSizeMake(frame.width * CGFloat(3), frame.height)
        scrollView!.setContentOffset(CGPointMake(frame.width, 0), animated: false)
        
        scrollView!.pagingEnabled = true
        scrollView!.showsHorizontalScrollIndicator = false
        scrollView!.showsVerticalScrollIndicator = false
        scrollView!.scrollsToTop = false
        scrollView!.directionalLockEnabled = true
        scrollView!.delegate = self
        
        addSubview(scrollView!)
    }
    
    func getPresentWeek(){
        var today = GDate()
        let todayOfWeek = today.getWeek().dayOfWeek
//        print(todayOfWeek)
        presentWeekDay = today.addDay(-todayOfWeek + 2)
//        let dadd = prevWeekDay.getWeek()
//        print(dadd.dayOfWeek)
        prevWeekDay = presentWeekDay.addDay(-7)
        nextWeekDay = presentWeekDay.addDay(7)
        for var i = 0; i < 7; i++ {
            let presentDate = presentWeekDay.addDay(i)
            presentWeek.append(presentDate)
            let prevDate = prevWeekDay.addDay(i)
            prevWeek.append(prevDate)
            let nextDate = nextWeekDay.addDay(i)
            nextWeek.append(nextDate)
        }
    }
    
    func initWeekView() {
        prevWeekView?.removeFromSuperview()
        prevWeekView = nil
        presentWeekView?.removeFromSuperview()
        presentWeekView = nil
        nextWeekView?.removeFromSuperview()
        nextWeekView = nil
        
        prevWeekView = CalendarWeekView(frame: CGRectMake(0, 0, frame.width, frame.height), dayInWeek: prevWeek)
        presentWeekView = CalendarWeekView(frame: CGRectMake(frame.width, 0, frame.width, frame.height), dayInWeek: presentWeek)
        nextWeekView = CalendarWeekView(frame: CGRectMake(frame.width * 2, 0, frame.width, frame.height), dayInWeek: nextWeek)
        prevWeekView!.delegate = self
        presentWeekView!.delegate = self
        nextWeekView!.delegate = self
        scrollView!.addSubview(prevWeekView!)
        scrollView!.addSubview(presentWeekView!)
        scrollView!.addSubview(nextWeekView!)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView.contentOffset.x > frame.width) {
            prevWeekDay = presentWeekDay
            presentWeekDay = nextWeekDay
            nextWeekDay = presentWeekDay.addDay(7)
            
            prevWeek = presentWeek
            presentWeek = nextWeek
            nextWeek = getDayOfWeek(nextWeekDay)
            
            delegate?.nextWeekView()
        } else if (scrollView.contentOffset.x < frame.width) {
            nextWeekDay = presentWeekDay
            presentWeekDay = prevWeekDay
            prevWeekDay = presentWeekDay.addDay(-7)
            
            nextWeek = presentWeek
            presentWeek = prevWeek
            prevWeek = getDayOfWeek(prevWeekDay)
            
            delegate?.prevWeekView()
        }
        initWeekView()
        scrollView.setContentOffset(CGPointMake(frame.width, 0), animated: false)
        setSelectDayInPresentWeek()
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPointMake(frame.width, 0), animated: false)
        initWeekView()
        presentWeekView!.selectDayFromWeek(selectedDay)
//        delegate!.afterAutoScroll()
    }
    
    func setSelectDayInPresentWeek() {
        let presentWeekEndDay = presentWeekDay.addDay(6)
        if selectedDay.between(presentWeekDay, presentWeekEndDay) {
            
        } else {
            presentWeekView!.selectFirstDayOfWeek()
            selectedDay = presentWeek[0]
        }
    }
    
    func scrollToPrevDay() {
        let nextSelectDay = selectedDay.addDay(-1)
        let nextDate = nextSelectDay.getDay()
        let presentWeekDayDate = presentWeekDay.getDay()
        if GDate(year: nextDate.year, month: nextDate.month, day: nextDate.day, hour: 0, minute: 0, second: 0) < GDate(year: presentWeekDayDate.year, month: presentWeekDayDate.month, day: presentWeekDayDate.day, hour: 0, minute: 0, second: 0) {
            nextWeekDay = presentWeekDay
            presentWeekDay = prevWeekDay
            prevWeekDay = presentWeekDay.addDay(-7)
            
            nextWeek = presentWeek
            presentWeek = prevWeek
            prevWeek = getDayOfWeek(prevWeekDay)
            
            delegate?.prevWeekView()
            scrollView!.setContentOffset(CGPointMake(0, 0), animated: true)
        } else {
            for (index, dayView) in presentWeekView!.dayViewOfWeek.enumerate() {
                if dayView.date == nextSelectDay {
                    dayView.isSelectedDay = true
                }
            }
        }
        delegate?.toPrevDay()
        selectedDay = nextSelectDay
    }
    
    func scrollToNextDay() {
        let nextSelectDay = selectedDay.addDay(1)
        let nextDate = nextSelectDay.getDay()
        let nextWeekDayDate = nextWeekDay.getDay()
        if GDate(year: nextDate.year, month: nextDate.month, day: nextDate.day, hour: 0, minute: 0, second: 0) >= GDate(year: nextWeekDayDate.year, month: nextWeekDayDate.month, day: nextWeekDayDate.day, hour: 0, minute: 0, second: 0) {
            prevWeekDay = presentWeekDay
            presentWeekDay = nextWeekDay
            nextWeekDay = presentWeekDay.addDay(7)
            
            prevWeek = presentWeek
            presentWeek = nextWeek
            nextWeek = getDayOfWeek(nextWeekDay)
            
            delegate?.nextWeekView()
            scrollView!.setContentOffset(CGPointMake(frame.width * 2, 0), animated: true)
        } else {
            for (index, dayView) in presentWeekView!.dayViewOfWeek.enumerate() {
                if dayView.date == nextSelectDay {
                    dayView.isSelectedDay = true
                }
            }
        }
        delegate?.toNextDay()
        selectedDay = nextSelectDay
    }
    
    func getDayOfWeek(weekDay: GDate) -> [GDate]{
        var weekDays = [GDate]()
        var day = weekDay
        for var i = 0; i < 7; i++ {
            let date = day.addDay(i)
            weekDays.append(date)
        }
        return weekDays
    }
    
    func selectedDay(dayView: CalendarDayView) {
        selectedDay = dayView.date!
        delegate?.daySelect()
    }
    
    func tapOnDay() {
        delegate?.tapOnDay()
    }
    
    func unSelectedDay(dayView: CalendarDayView) {
        
    }
}
