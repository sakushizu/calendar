//
//  TitleTableViewCell.swift
//  CalendarApp
//
//  Created by 櫻本静香 on 2016/07/30.
//  Copyright © 2016年 Sakuramoto Shizuka. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpTitleTextField()
        
    }

    func fillWith(row: Int, titleText: String){
        self.titleTextField.text = titleText
    }
    
    private func setUpTitleTextField() {
        titleTextField.placeholder = "Write a title"
            titleTextField.font = UIFont.mainFontJa(15)
        titleTextField.textColor = UIColor.hexStr("555555", alpha: 1)
    }
    
}
