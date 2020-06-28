//
//  ViewControllerOne.swift
//  GomeSwift
//
//  Created by caoye on 2020/5/23.
//  Copyright © 2020 caoye. All rights reserved.
//

import UIKit

class ViewControllerOne: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        
        let textField = UITextField();
        textField.backgroundColor = UIColor.red
        textField.frame = CGRect(x: 0, y: 600, width: screenW, height: 40)
        self.view.addSubview(textField)
        
        
        let textField1 = UITextView();
        textField1.backgroundColor = UIColor.red
        textField1.frame = CGRect(x: 0, y: 700, width: screenW, height: 100)
        self.view.addSubview(textField1)
    }
    
    deinit {

        print("delloc")
    }

}
