//
//  CYCollectionCell.swift
//  swift_test
//
//  Created by cy on 14-6-4.
//  Copyright (c) 2015年 cy. All rights reserved.
//

import Foundation
import UIKit

class CYCollectionCell: UICollectionViewCell {

    var tmpCellImage : UIImageView?
    
    internal var cellImageView : UIImageView {
    
        set{
        
            self.tmpCellImage = newValue
        }
        get {
            
            if self.tmpCellImage == nil {
            
                self.tmpCellImage = UIImageView(frame: self.contentView.frame)
                self.tmpCellImage?.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                self.tmpCellImage?.backgroundColor = UIColor.lightGrayColor()
            }
            
            return self.tmpCellImage!
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.contentView.addSubview(cellImageView)
    }
}