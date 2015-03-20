//
//  XCell.h
//  zaweather
//
//  Created by duangl on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCell : UITableViewCell
{
    IBOutlet UIView * background;
    IBOutlet UILabel * title;
    IBOutlet UIImageView * image1;
    IBOutlet UIImageView * image2;
    IBOutlet UIImageView * noselect;
    IBOutlet UIImageView * isselect;
    int index1;
    int index2;

}
@property(nonatomic,retain) UIView * background;
@property(nonatomic,retain) UILabel * title;
@property(nonatomic,retain) UIImageView * image1;
@property(nonatomic,retain) UIImageView * image2;
@property(nonatomic,retain) UIImageView * isselect;
@property(nonatomic,retain) UIImageView * noselect;
@property int index1;
@property int index2;

@end
