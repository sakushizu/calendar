//
//  SignUpViewController.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2015/12/16.
//  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit
import RSKImageCropper
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class SignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, UITextFieldDelegate {
    
    let images = ["user", "Mail", "Lock"]
    let placeholderTexts = ["Username", "Mail Address", "Password"]
    
    var pickerVC: UIImagePickerController!
    var selectImage: UIImage!
    var userImageCell: UserImageTableViewCell!
    var userInfoCell: CreateUserTableViewCell!
    
    var customButton:UIButton!
    var isLogin = false
    
    var overMinPasswordTextCount = false
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.mainColor()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "CreateUserTableViewCell", bundle: nil), forCellReuseIdentifier: "createUserCell")
        tableView.registerNib(UINib(nibName: "OrViewTableViewCell", bundle: nil), forCellReuseIdentifier: "orCell")
        tableView.registerNib(UINib(nibName: "NextBtnTableViewCell", bundle: nil), forCellReuseIdentifier: "nextCell")
        tableView.registerNib(UINib(nibName: "FaceBookTableViewCell", bundle: nil), forCellReuseIdentifier: "faceBookCell")
        tableView.registerNib(UINib(nibName: "UserImageTableViewCell", bundle: nil), forCellReuseIdentifier: "userImageCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let boundSize: CGSize = UIScreen.mainScreen().bounds.size
        let navigationBarHeight = navigationController!.navigationBar.frame.height
        let cellsHeight: CGFloat = 65 * 5
        return (boundSize.height - (20 + navigationBarHeight + cellsHeight + 160)) / 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            userImageCell = tableView.dequeueReusableCellWithIdentifier("userImageCell", forIndexPath: indexPath) as! UserImageTableViewCell
            userImageCell.libraryBtn.addTarget(self, action: #selector(SignUpViewController.tappedLibraryPhotoBtn), forControlEvents: .TouchUpInside)
            userImageCell.takePhotoBtn.addTarget(self, action: #selector(SignUpViewController.tappedTakePhotoBtn), forControlEvents: .TouchUpInside)
            userImageCell.userImageView.layer.cornerRadius = userImageCell.userImageView.frame.width / 2
            userImageCell.clipsToBounds = true
            return userImageCell
        } else if indexPath.section == 1 {
            userInfoCell = tableView.dequeueReusableCellWithIdentifier("createUserCell", forIndexPath: indexPath) as! CreateUserTableViewCell
            userInfoCell.textField.delegate = self
            userInfoCell.icon.image = UIImage(named: images[indexPath.row])
            userInfoCell.textField.placeholder = placeholderTexts[indexPath.row]
            if indexPath.row == 2 {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextInputDelegate.textDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: userInfoCell.textField)
            }
            return userInfoCell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("faceBookCell", forIndexPath: indexPath) as! FaceBookTableViewCell
            cell.faceBookLabel.text = "Sign Up With Facebook"
            return cell
        } else {
            let nextCell = tableView.dequeueReusableCellWithIdentifier("nextCell", forIndexPath: indexPath) as! NextBtnTableViewCell
            return nextCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 3 {
            let nameCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! CreateUserTableViewCell
            let mailCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as! CreateUserTableViewCell
            let passwordCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) as! CreateUserTableViewCell
            if nameCell.textField.text == "" || passwordCell.textField.text == "" || mailCell.textField.text == "" {
                showAlert("exist empty text field")
            } else if overMinPasswordTextCount == false {
                showAlert("password is min 6 count")
            } else {
                let params: [String:AnyObject] = [
                    "name": nameCell.textField.text!,
                    "password": passwordCell.textField.text!,
                    "mail": mailCell.textField.text!,
                    "avatar": userImageCell.userImageView.image!
                ]
                User.signUpRails(params, completion: {
                    UserInvitationManager.sharedInstance.fetchInvitationCalendars(completion: {
                    })
                    CalenderManager.sharedInstance.fetchCalendars(completion: {
                    })
                    let controller = UIStoryboard.viewControllerWith("Calendar", identifier: "CalendarViewController")
                    let navigationController = UINavigationController(rootViewController: controller)
                    self.presentViewController(navigationController, animated: true, completion: nil)
                })
            }
        } else if indexPath.section == 2 {
            FaceBookLoginButtonClicked()
        } else if indexPath.section == 0 {
            userImageCell.selected = true
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        } else {
            return 65
        }
    }

    func tappedLibraryPhotoBtn() {
        pickImageFromLibrary()
    }
    
    func tappedTakePhotoBtn() {
        pickImageFromCamera()
        if userImageCell.selected {
            
        }
    }
    
    //アラートを表示させるメソッドを定義
    func showAlert(message: String?) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textDidChange(notification: NSNotification) {
        if notification.object?.text.characters.count > 6 {
            overMinPasswordTextCount = true
        }
    }
    
    ///////facebookButton
    func makeFBRoginBtn() -> UIButton {
        customButton = UIButton(type: .System)
        customButton.setTitle("Sign Up With Facebook", forState: .Normal)
        customButton.addTarget(self, action: #selector(self.FaceBookLoginButtonClicked), forControlEvents: .TouchUpInside)
        customButton.frame = CGRectMake(0,0,self.view.frame.width,80)
        return customButton
        
    }
    
    //////ログインボタン
    func FaceBookLoginButtonClicked(){
        
        let loginManager = FBSDKLoginManager()
        if(!isLogin){
            loginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result, error) in
                guard error == nil else {
                    return
                }
                if result.isCancelled {
                } else {
                    User.getUserData({
                        let controller = UIStoryboard.viewControllerWith("Calendar", identifier: "CalendarViewController")
                        let navigationController = UINavigationController(rootViewController: controller)
                        self.presentViewController(navigationController, animated: true, completion: nil)
                        CalenderManager.sharedInstance.fetchCalendars(completion: {
                            
                        })
                    })
//                    self.customButton.setTitle("Logout", forState: .Normal)
                }
            }
        } else {
            loginManager.logOut()
            customButton.setTitle("My Login Button", forState: .Normal)
        }
        self.isLogin = !self.isLogin
    }
    
    //////////ここから///////
    
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(pickerVC, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            selectImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: selectImage, cropMode: RSKImageCropMode.Square)
        imageCropVC.delegate = self // 必須（下で実装）
        imageCropVC.dataSource = self // トリミングしたい領域をカスタマイズする際には必要
        picker.pushViewController(imageCropVC, animated: true)
    }

    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController) -> CGRect {
        
        var maskSize: CGSize
        var height: CGFloat!
        
//        width = self.view.frame.width
        
        // 縦横比 = 1 : 2でトリミングしたい場合
        //        height = self.view.frame.width / 2
        
        // 正方形でトリミングしたい場合
        height = self.view.frame.width
        
        maskSize = CGSizeMake(self.view.frame.width, height)
        
        let viewWidth: CGFloat = CGRectGetWidth(controller.view.frame)
        let viewHeight: CGFloat = CGRectGetHeight(controller.view.frame)
        
        let maskRect: CGRect = CGRectMake((viewWidth - maskSize.width) * 0.5, (viewHeight - maskSize.height) * 0.5, maskSize.width, maskSize.height)
        return maskRect
    }
    
    // トリミングしたい領域を描画（今回は四角な領域です・・・）
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController) -> UIBezierPath {
        let rect: CGRect = controller.maskRect
        
        let point1: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
        let point2: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        let point3: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))
        let point4: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        let square: UIBezierPath = UIBezierPath()
        square.moveToPoint(point1)
        square.addLineToPoint(point2)
        square.addLineToPoint(point3)
        square.addLineToPoint(point4)
        square.closePath()
        
        return square
    }
    
    func imageCropViewControllerCustomMovementRect(controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
    
    // キャンセルがおされたらトリミング画面を閉じます
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        pickerVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // トリミング前に呼ばれるようです今回は使っていませんが、ないとコンパイルできないので定義しておきます
    func imageCropViewController(controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
    }
    
    // トリミング済みの画像がかえされます
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        pickerVC.dismissViewControllerAnimated(true, completion: nil)
        userImageCell.userImageView.image = croppedImage
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
