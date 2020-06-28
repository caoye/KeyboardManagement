//
//  HeaderCollectionCell.swift
//  GomeSwift
//
//  Created by caoye on 2020/5/23.
//  Copyright © 2020 caoye. All rights reserved.
//

import UIKit

class HeaderCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .lightGray

        let textField = UITextField();
        textField.backgroundColor = UIColor.red
        textField.frame = CGRect(x: 0, y: 30, width: screenW, height: 40)
        self.contentView.addSubview(textField)
        
    }
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }
    
    
    
    class func getCellSize(_ dataModel:Any) ->CGSize {
        let cellH:CGFloat = 100
        return CGSize(width: screenW, height: cellH)
    }
}
