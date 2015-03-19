//
//  ImageShowViewController.swift
//  swift_test
//
//  Created by cy on 14-6-4.
//  Copyright (c) 2015年 cy. All rights reserved.
//

import Foundation
import UIKit

class ImageShowViewController : UIViewController {
    
    var viewImage : UIImage?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        var scrollView = ShowImageScrollView(frame: self.view.bounds)
        scrollView.initialShowImage(viewImage!)
        
        self.view.addSubview(scrollView)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
}
