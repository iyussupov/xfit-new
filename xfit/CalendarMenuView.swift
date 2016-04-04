//
//  CalendarMenuView.swift
//

import UIKit

class CalendarMenuView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var weekDayName = ["ПН", "ВТ", "СР", "ЧТ", "ПН", "СБ", "ВС"]
    var padding: CGFloat = 0.0
    var labelFont: UIFont = UIFont(name: "DINPro", size: 14)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDayLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initDayLabel() {
        let height = frame.height
        let width = (frame.width  - 1 - padding * 6) / 7
        var rect = CGRectMake(0, 0, width, height)
        
        for (index, name) in  weekDayName.enumerate() {
            rect.origin.x =  CGFloat(index) * (width + padding)
            let label = UILabel(frame: rect)
            label.text = name
            label.textAlignment = .Center
            label.textColor = UIColor.whiteColor()
            if index == 5 || index == 6 {
                label.textColor = UIColor(red: 252/255, green: 212/255, blue: 0/255, alpha: 1.0)
            }
            label.font = labelFont
            addSubview(label)
        }
    }
    
    

}
