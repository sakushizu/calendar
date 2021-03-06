//
//  CreateCalendar.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/08.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import Bond

class CreateCalendarVM: NSObject, UITableViewDataSource, UITextFieldDelegate {
    
    var selectStampImage = UIImage(named: "approval")
    var selectColor = CalendarThemeColor(r: 248, g: 151, b: 190)
    var titleText = Observable<String?>("")
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rowType = RowType(rawValue: indexPath.row)!
        
        switch rowType {
            
        case .TitleCell:
            let cell = tableView.dequeueReusableCellWithIdentifier("TitleTableViewCell", forIndexPath: indexPath) as! TitleTableViewCell
            cell.fillWith(indexPath.row, titleText: self.titleText.value!)
            cell.titleTextField.bnd_text.bindTo(titleText)
            return cell
            
        case .StampCell:
            let stampCell = tableView.dequeueReusableCellWithIdentifier("StampImageTableViewCell", forIndexPath: indexPath) as! StampImageTableViewCell
            stampCell.fillWith(selectStampImage!)
            return stampCell

        case .ColorCell:
            let cell = tableView.dequeueReusableCellWithIdentifier("ColorTableViewCell", forIndexPath: indexPath) as! ColorTableViewCell
            cell.fillWith(selectColor.color)            
            return cell
            
        case.UserCell:
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectUserTableViewCell", forIndexPath: indexPath) as! SelectUserTableViewCell
            return cell
        }
    }
        

}
