//
//  CreateCalendarViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/08.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

enum RowType: Int {
    case TitleCell = 0
    case StampCell = 1
    case ColorCell = 2
    case UserCell = 3
}

enum StampViewType: Int {
    case Down = 0
    case Up = 1
}

class CreateCalendarViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    private let mModel = CreateCalendarVM()
    private var mView: CreateCalendarView!
    private var imagePickerVC: UIImagePickerController!
    private var stampCollectionView = StampCollectionView()
    private var selectedUserCollectionVM = SelectedUserCollectionVM()
    private var stampViewCount = StampViewType.Down
    private let userInvitationManager = UserInvitationManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        mView = view as! CreateCalendarView
        mView.tableView.dataSource = mModel
        mView.tableView.delegate = self
        mView.createButton.addTarget(self, action: #selector(CreateCalendarViewController.clickCreateButton), forControlEvents: .TouchUpInside)
        
        setImagePicker()
        setStampNotification()
        mView.addSubview(stampCollectionView)
    }

    override func viewWillAppear(animated: Bool) {
        setNavigationBar()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowType = RowType(rawValue: indexPath.row)!
        
        switch rowType {
        case .TitleCell, .ColorCell, .UserCell:
            return 50
            
        case .StampCell:
            return 90
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowType = RowType(rawValue: indexPath.row)!
        
        if rowType == .ColorCell {
            
            let colorTableVC = UIStoryboard.viewControllerWith("CreateCalendar", identifier: "colorTableViewController") as! ColorTableViewController
            self.navigationController?.pushViewController(colorTableVC, animated: true)
            
        } else if rowType == .UserCell {
    
            userInvitationManager.fetchUsers(
                completion: {
                let controller = UIStoryboard.viewControllerWith("CreateCalendar", identifier: "UserInvitationViewController") as! UserInvitationViewController
                let navigationController = UINavigationController(rootViewController: controller)
                self.presentViewController(navigationController, animated: true, completion: nil)
                }, fail: {
                    API.fail(self)
                }
            )
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage? {
            mModel.selectStampImage = pickedImage
            mView.tableView.reloadData()
        }
        
        imagePickerVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clickCreateButton() {
        
        if mModel.titleText.value! == "" {
            let alert = UIAlertController.alertWith(message: "Title is empty!")
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let navigationVC = self.navigationController!
            navigationVC.popViewControllerAnimated(false)
            let calendarVC = navigationVC.viewControllers.last as! CalendarTopViewController
            self.save(calendarVC)
        }
    }

    //MARK: -> notification
    
    func stampImageNotification(notification: NSNotification) {
        showImagePickActionSheet()
    }
    
    func closeStampImageNotification(notification: NSNotification) {
        self.setStampController()
    }
    func selectStampNotification(notification: NSNotification) {
        let indexPath = NSIndexPath(forRow: RowType.StampCell.rawValue, inSection: 0)
        if let userInfo = notification.userInfo {
            mModel.selectStampImage = userInfo["stampImage"] as? UIImage
            mView.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    func selectColorNotification(notification: NSNotification) {
        let indexPath = NSIndexPath(forRow: RowType.ColorCell.rawValue, inSection: 0)
        if let userInfo = notification.userInfo {
            mModel.selectColor = (userInfo["color"] as? CalendarThemeColor)!
            mView.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            mView.tableView.reloadData()
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    private func setStampNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CreateCalendarViewController.stampImageNotification(_:)),
            name: "tappedStampImageNotification",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CreateCalendarViewController.closeStampImageNotification(_:)),
            name: "closeStampImageNotification",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CreateCalendarViewController.selectStampNotification(_:)),
            name: "selectStampNotification",
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CreateCalendarViewController.selectColorNotification(_:)),
            name: "selectColorNotification",
            object: nil
        )
    }
    
    
    
    private func showImagePickActionSheet() {
        
        let actionSheet = UIAlertController(
            title:"Select Stamp Icon",
            message: nil,
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil
        )
        
        let choosePhotoAction = UIAlertAction(
            title: "Choose from library",
            style: UIAlertActionStyle.Default,
            handler: { action in
                self.imagePickerVC.sourceType = .PhotoLibrary
                self.imagePickerVC.allowsEditing = true
                self.presentViewController(self.imagePickerVC, animated: true, completion: nil)
            }
        )
        
        let takePhotoAction = UIAlertAction(
            title: "Take photo",
            style: UIAlertActionStyle.Default,
            handler: { action in
                self.imagePickerVC.sourceType = .Camera
                self.imagePickerVC.allowsEditing = true
                self.presentViewController(self.imagePickerVC, animated: true, completion: nil)
            }
        )
        
        let chooseStampAction = UIAlertAction(
            title: "Choose from Stamps",
            style: UIAlertActionStyle.Default,
            handler: { action in
                self.setStampController()
            }
        )
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(choosePhotoAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(chooseStampAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    

    private func setImagePicker() {
        imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
    }
    
    private func setStampController() {
        stampBtn()
    }
    

    
    //MARK: -> StampCollectionView表示切り替え
    private func stampBtn() {
        if stampViewCount == .Down {
            stampViewCount = .Up
            UICollectionView.animateWithDuration(0.3) {
                self.stampCollectionView.frame.origin = CGPointMake(0, self.view.frame.height - 300)
            }
        } else {
            stampViewCount = .Down
            UICollectionView.animateWithDuration(0.3) {
                self.stampCollectionView.frame.origin = CGPointMake(0, self.view.frame.height)
            }
        }
    }
    
    private func save(calendarVC: CalendarTopViewController) {
        
        
        let params: [String: AnyObject] = [
            "title": mModel.titleText.value!,
            "stamp": mModel.selectStampImage!,
            "color_r": mModel.selectColor.r,
            "color_g": mModel.selectColor.g,
            "color_b": mModel.selectColor.b,
            "user_ids": setUserIdArray()
        ]
        
        CalenderManager.sharedInstance.saveCalendarRails(params, completion: { })
        
    }
    
    private func setUserIdArray() -> String {
        var userIdArray = [String]()
        for user in selectedUserCollectionVM.users {
            userIdArray.append(user.id.description)
        }
        let userIds = userIdArray.joinWithSeparator(",")
        return userIds
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.hidesNavigationBarHairline = true
        self.navigationController?.navigationBar.tintColor = UIColor.mainColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationItem.title = "Create Calendar"
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
    }
    
    
}
