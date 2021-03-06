////
////  UserEditTableview.swift
////  CalendarApp
////
////  Created by 櫻本静香 on 2015/12/25.
////  Copyright © 2015年 Sakuramoto Shizuka. All rights reserved.
////
//
//import UIKit
//import RSKImageCropper
//
//class UserEditTableview: UITableView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource {
//    
////    let images = ["User", "Mail", "Lock"]
////    let placeholderTexts = ["Username", "Mail Address", "Password"]
////    let nextLabelTexts = ["Update Profile", "Logout"]
////    
////    var userImageCell: UserImageTableViewCell!
////
////    //ソースコードでインスタンスを生成した場合
////    override init(frame: CGRect, style: UITableViewStyle) {
////        super.init(frame: frame, style: style)
////        
////        self.delegate = self
////        self.dataSource = self
////        
////        self.registerNib(UINib(nibName: "CreateUserTableViewCell", bundle: nil), forCellReuseIdentifier: "createUserCell")
////        self.registerNib(UINib(nibName: "UserImageTableViewCell", bundle: nil), forCellReuseIdentifier: "userImageCell")
////        self.registerNib(UINib(nibName: "NextBtnTableViewCell", bundle: nil), forCellReuseIdentifier: "nextCell")
////    }
////    
////    required init?(coder aDecoder: NSCoder) {
////        super.init(coder: aDecoder)
////    }
////    
////    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
////        return 3
////    }
////    
////    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        if section == 1 {
////            return 3
////        } else if section == 2 {
////            return 2
////        } else {
////            return 1
////        }
////    }
////    
////    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
////        if indexPath.section == 0 {
////            userImageCell = tableView.dequeueReusableCellWithIdentifier("userImageCell", forIndexPath: indexPath) as! UserImageTableViewCell
////            userImageCell.libraryBtn.addTarget(self, action: "tappedLibraryPhotoBtn", forControlEvents: .TouchUpInside)
////            userImageCell.takePhotoBtn.addTarget(self, action: "tappedTakePhotoBtn", forControlEvents: .TouchUpInside)
////            userImageCell.userImageView.layer.cornerRadius = userImageCell.userImageView.frame.width / 2
////            userImageCell.clipsToBounds = true
////            return userImageCell
////        } else if indexPath.section == 1 {
////            let userInfoCell = tableView.dequeueReusableCellWithIdentifier("createUserCell", forIndexPath: indexPath) as! CreateUserTableViewCell
////            userInfoCell.textField.delegate = self
////            userInfoCell.icon.image = UIImage(named: images[indexPath.row])
////            userInfoCell.textField.placeholder = placeholderTexts[indexPath.row]
////            return userInfoCell
////        } else {
////            let cell = tableView.dequeueReusableCellWithIdentifier("nextCell", forIndexPath: indexPath) as! NextBtnTableViewCell
////            cell.nextLabel.text = nextLabelTexts[indexPath.row]
////            return cell
////        }
////    }
////    
////    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
////        return 100
////    }
////    
////    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        return 40
////    }
////    
////    func textFieldShouldReturn(textField: UITextField) -> Bool {
////        textField.resignFirstResponder()
////        return true
////    }
////    
////    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
////        if indexPath.section == 2 {
////            let nameCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! CreateUserTableViewCell
////            let passwordCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as! CreateUserTableViewCell
////            let mailCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) as! CreateUserTableViewCell
////            if nameCell.textField.text == "" || passwordCell.textField.text == "" || mailCell.textField.text == "" {
////                showAlert("exist empty text field")
////            } else {
////                let user = User(name: nameCell.textField.text!, password: passwordCell.textField.text!, mailAddress: mailCell.textField.text!, userImage: userImageCell.userImageView.image!)
////                user.signUp { (message) in
////                    if let unwrappedMessage = message {
////                        self.showAlert(unwrappedMessage)
////                        print("サインアップ失敗")
////                    } else {
////                        print("サインアップ成功")
//////                        self.performSegueWithIdentifier("login", sender: nil)
////                    }
////                }
////            }
////        } else if indexPath.section == 1 {
////            
////        } else if indexPath.section == 0 {
////            userImageCell.selected = true
////        }
////
////    }
////    
////    func tappedLibraryPhotoBtn() {
////        pickImageFromLibrary()
////    }
////    
////    func tappedTakePhotoBtn() {
////        pickImageFromCamera()
////        if userImageCell.selected {
////            
////        }
////    }
////    
////    //アラートを表示させるメソッドを定義
////    func showAlert(message: String?) {
////        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
////        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
////        alertController.addAction(action)
////        presentViewController(alertController, animated: true, completion: nil)
////    }
////
////    
////    // 写真を撮ってそれを選択
////    func pickImageFromCamera() {
////        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
////            let controller = UIImagePickerController()
////            controller.delegate = self
////            controller.sourceType = UIImagePickerControllerSourceType.Camera
////            self.presentViewController(controller, animated: true, completion: nil)
////        }
////    }
////    
////    // ライブラリから写真を選択する
////    func pickImageFromLibrary() {
////        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
////            pickerVC = UIImagePickerController()
////            pickerVC.delegate = self
////            pickerVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
////            presentViewController(pickerVC, animated: true, completion: nil)
////        }
////    }
////    
////    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
////        if info[UIImagePickerControllerOriginalImage] != nil {
////            selectImage = info[UIImagePickerControllerOriginalImage] as! UIImage
////        }
////        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: selectImage, cropMode: RSKImageCropMode.Square)
////        imageCropVC.delegate = self // 必須（下で実装）
////        imageCropVC.dataSource = self // トリミングしたい領域をカスタマイズする際には必要
////        picker.pushViewController(imageCropVC, animated: true)
////    }
////    
////    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController) -> CGRect {
////        
////        var maskSize: CGSize
////        var width, height: CGFloat!
////        
////        width = self.view.frame.width
////        
////        // 縦横比 = 1 : 2でトリミングしたい場合
////        //        height = self.view.frame.width / 2
////        
////        // 正方形でトリミングしたい場合
////        height = self.view.frame.width
////        
////        maskSize = CGSizeMake(self.view.frame.width, height)
////        
////        let viewWidth: CGFloat = CGRectGetWidth(controller.view.frame)
////        let viewHeight: CGFloat = CGRectGetHeight(controller.view.frame)
////        
////        let maskRect: CGRect = CGRectMake((viewWidth - maskSize.width) * 0.5, (viewHeight - maskSize.height) * 0.5, maskSize.width, maskSize.height)
////        return maskRect
////    }
////    
////    // トリミングしたい領域を描画（今回は四角な領域です・・・）
////    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController) -> UIBezierPath {
////        let rect: CGRect = controller.maskRect
////        
////        let point1: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
////        let point2: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
////        let point3: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))
////        let point4: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))
////        
////        let square: UIBezierPath = UIBezierPath()
////        square.moveToPoint(point1)
////        square.addLineToPoint(point2)
////        square.addLineToPoint(point3)
////        square.addLineToPoint(point4)
////        square.closePath()
////        
////        return square
////    }
////    
////    func imageCropViewControllerCustomMovementRect(controller: RSKImageCropViewController) -> CGRect {
////        return controller.maskRect
////    }
////    
////    // キャンセルがおされたらトリミング画面を閉じます
////    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
////        pickerVC.dismissViewControllerAnimated(true, completion: nil)
////    }
////    
////    // トリミング前に呼ばれるようです今回は使っていませんが、ないとコンパイルできないので定義しておきます
////    func imageCropViewController(controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
////    }
////    
////    // トリミング済みの画像がかえされます
////    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
////        pickerVC.dismissViewControllerAnimated(true, completion: nil)
////        userImageCell.userImageView.image = croppedImage
////        tableView.reloadData()
////    }
//}
