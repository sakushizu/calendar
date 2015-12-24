//
//  MenuTableViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/10.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

protocol MenuTableViewControllerDelegate {
    func menuControllerDidSelectRow(indexPath:NSIndexPath)
}

class MenuTableViewController: UITableViewController {
    
    let sectionTitles = ["", "Private", "Group"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "sideUserTableViewCell", bundle: nil), forCellReuseIdentifier: "sideUserCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    var delegate : MenuTableViewControllerDelegate?
    var tableData : Array<String> = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if CalenderManager.sharedInstance.groupCalendarCollection.count > 0 {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return CalenderManager.sharedInstance.calendarCollection.count
        } else {
            return CalenderManager.sharedInstance.groupCalendarCollection.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.darkGrayColor()
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        cell.selectedBackgroundView = selectedBackgroundView
        if indexPath.section == 0 {
            let userCell = self.tableView.dequeueReusableCellWithIdentifier("sideUserCell", forIndexPath: indexPath) as! sideUserTableViewCell
            userCell.backgroundColor = UIColor.clearColor()
            if CurrentUser.sharedInstance.user == nil {
                userCell.userImageView.image = UIImage(named: "User")
                userCell.nameLabel.text = "guest"
            } else {
                userCell.userImageView.image = CurrentUser.sharedInstance.user.userImage
                userCell.nameLabel.text = CurrentUser.sharedInstance.user.name
            }
            userCell.settingButton.addTarget(self, action: "tappedSettingBtn", forControlEvents: .TouchUpInside)
            return userCell
        } else if indexPath.section == 1 {
            //group calendar cell
            let calendar = CalenderManager.sharedInstance.calendarCollection[indexPath.row]
            cell.textLabel?.text = calendar.title
            return cell
        } else {
            let calendar = CalenderManager.sharedInstance.groupCalendarCollection[indexPath.row]
            cell.textLabel?.text = calendar.title
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100.0
        } else {
            return 50.0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.menuControllerDidSelectRow(indexPath)
    }
    
    func tappedSettingBtn() {
    }

}