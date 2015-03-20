//
//  weatherAddCityViewController.m
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherAddCityViewController.h"
#import "weatherAppDelegate.h"
#import "weatherTodayViewController.h"
#import "weatherLiveViewController.h"
#import "NSObject+SBJson.h"
#import "weatherWeakViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
@implementation weatherAddCityViewController
@synthesize background;
@synthesize buttonLeft;
@synthesize buttonRight;
@synthesize tableView;
@synthesize dataArray;
@synthesize isClick;
@synthesize citylist;

@synthesize sourceData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"城市添加";	
        self.tabBarItem.image = [UIImage imageNamed:@"baricon_4"];
        
        weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

        sourceData = app.sourceData;
        dataArray = app.city;

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.tableView beginUpdates];
//    [tableView setEditing:YES animated:YES];
    isClick = NO;
    // Do any additional setup after loading the view from its nib.

    //创建一个左边按钮
    [tableView setBackgroundColor:[UIColor clearColor]];
    [buttonLeft addTarget:self action:@selector(clickleftButton) forControlEvents:UIControlEventTouchUpInside];
    [buttonRight addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];

    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://219.235.240.51/api/addcity.json"]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client getPath:@"" parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
                
        [client release];   
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
    }];
    
}

- (void)clickleftButton
{
    if(isClick == YES)
        [self clickRightButton];
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    self.citylist = [[weatherCityListViewController alloc] initWithNibName:@"weatherCityListViewController" bundle:nil];
    self.citylist.delegate = self;
    [app.tabBarController presentModalViewController:citylist animated:YES];
}
- (void)clickRightButton
{
    if(isClick == NO)
    {
       // 
        [self.tableView setEditing:YES animated:YES];
        [self.buttonRight setTitle:@"完成" forState:UIControlStateNormal];
        isClick = YES;
    }else {
        [self.tableView setEditing:NO animated:YES];
        //
        [self.buttonRight setTitle:@"编辑" forState:UIControlStateNormal];
        isClick = NO;
    }
}

- (void)clickFinishButton
{
    
//    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
//    
//    id citydata = [[[app.sourceData objectAtIndex:pickerIndex1] objectForKey:@"citys"] objectAtIndex:pickerIndex2];
//    
//    if([dataArray count]>= 10)
//    {
//        [[[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多添加十个城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease] show];
//        return;
//    }
//    
//    for (weatherCityData * cell in app.city) {
//        if([cell.cityName isEqual:[citydata objectForKey:@"name"]])
//        {
//          [[[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您已添加过此城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease] show];
//            
//            if(!tableView.editing)
//                [self.buttonRight setTitle:@"编辑" forState:UIControlStateNormal];
//            [self.buttonLeft setTitle:@"添加" forState:UIControlStateNormal];
//            [buttonRight removeTarget:self action:@selector(clickFinishButton)  forControlEvents:UIControlEventTouchUpInside];
//            [buttonRight addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
//            [self.tableView setUserInteractionEnabled:YES];
////            [self.picker setHidden:YES];
//            
//            return;
//        }
//        
//    }
//    
//    weatherCityData * city = [[[weatherCityData alloc] init] autorelease];
//    NSLog(@"app,%d",[app.fileData count]);
//    [app.fileData addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[NSNumber numberWithInt:pickerIndex1] stringValue],@"index1",[[NSNumber numberWithInt:pickerIndex2] stringValue],@"index2",nil]];
//    [[app.fileData JSONRepresentation] writeToFile:[NSString stringWithFormat:@"%@/record.json",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]] atomically:NO encoding:NSUTF8StringEncoding error:nil];
//    
//    city.weatherCode = [citydata objectForKey:@"weatherCode"];
//    city.cityName = [citydata objectForKey:@"name"];
//    city.adCode99 = [citydata objectForKey:@"adCode99"];
//    city.bgID = [[app.city lastObject] bgID] + 1 ;
//    if (city.bgID >= [app.backgroundToday count]) city.bgID = 0;
//    city.tags = [app.city count];
//    [app.city addObject:city];
//    
//    [((weatherTodayViewController*)[[app.tabBarController viewControllers] objectAtIndex:0]) addView:[app.city count]-1];
//    [((weatherLiveViewController*)[[app.tabBarController viewControllers] objectAtIndex:1]) addView:[app.city count]-1];
//     [((weatherWeakViewController*)[[app.tabBarController viewControllers] objectAtIndex:2]) addView:[app.city count]-1];
//
//    //[self.tableView beginUpdates];
//    [tableView reloadData];
//    [app refresh:city.tags];
//  //  [self.tableView endUpdates];
//    
//    if(!tableView.editing)
//        [self.buttonRight setTitle:@"编辑" forState:UIControlStateNormal];
//    [self.buttonLeft setTitle:@"添加" forState:UIControlStateNormal];
//    [buttonRight removeTarget:self action:@selector(clickFinishButton)  forControlEvents:UIControlEventTouchUpInside];
//    [buttonRight addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.tableView setUserInteractionEnabled:YES];
//    [self.picker setHidden:YES];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}
- (void)viewWillAppear:(BOOL)animated;     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate];  
    
    [background setImage:[UIImage imageNamed:[app.backgroundAddCity objectAtIndex:[[app.city objectAtIndex:app.currentCityIndex] bgID]]]];
    [buttonLeft setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_1",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateNormal];
    [buttonLeft setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_2",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateHighlighted];
    [buttonRight setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_1",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateNormal];
    [buttonRight setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_2",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateHighlighted];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    // Return the number of sections. 
    return 1; 
} 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    // Return the number of rows in the section. 
    return [dataArray count]; 
} 


// Customize the appearance of table view cells. 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    static NSString *CellIdentifier = @"Cell"; 
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    if (cell == nil) { 
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease]; 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    } 
    
    // Configure the cell... 
    cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] cityName]; 
    return cell; 
} 
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return YES; 
} 

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { 
    
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
        if([dataArray count]== 1)
        {
            [[[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请至少保留一个城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease] show];
            return;
        }

        [dataArray removeObjectAtIndex:indexPath.row]; 
        // Delete the row from the data source. 
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade]; 
        [self.tableView endUpdates];
        weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

        [((weatherTodayViewController*)[[app.tabBarController viewControllers] objectAtIndex:0]) deleteView:indexPath.row];
        [((weatherLiveViewController*)[[app.tabBarController viewControllers] objectAtIndex:1]) deleteView:indexPath.row];
        [((weatherWeakViewController*)[[app.tabBarController viewControllers] objectAtIndex:2]) deleteView:indexPath.row];
        
        [app.fileData removeObjectAtIndex:indexPath.row];
        [[app.fileData JSONRepresentation] writeToFile:[NSString stringWithFormat:@"%@/record.json",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]] atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        for (int i=0; i<[dataArray count]; i++) {
            [(weatherCityData*)([dataArray objectAtIndex:i]) setTags:i];
        }
        
    }    
    else if (editingStyle == UITableViewCellEditingStyleInsert) { 
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view. 
//        [self.tableView beginUpdates];
//        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade]; 
//        [self.tableView endUpdates];
    }    
} 
-(void) AddCityWithIndex1:(int) index1 WithIndex2:(int) index2
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    
    id citydata = [[[app.sourceData objectAtIndex:index1] objectForKey:@"citys"] objectAtIndex:index2];
    
    weatherCityData * city = [[[weatherCityData alloc] init] autorelease];
    NSLog(@"app,%d",[app.fileData count]);
    [app.fileData addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[NSNumber numberWithInt:index1] stringValue],@"index1",[[NSNumber numberWithInt:index2] stringValue],@"index2",nil]];
    [[app.fileData JSONRepresentation] writeToFile:[NSString stringWithFormat:@"%@/record.json",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    city.weatherCode = [citydata objectForKey:@"weatherCode"];
    city.cityName = [citydata objectForKey:@"name"];
    city.bgID = [[app.city lastObject] bgID] + 1 ;
    if (city.bgID >= [app.backgroundToday count]) city.bgID = 0;
    city.tags = [app.city count];
    [app.city addObject:city];
    
    [((weatherTodayViewController*)[[app.tabBarController viewControllers] objectAtIndex:0]) addView:[app.city count]-1];
    [((weatherLiveViewController*)[[app.tabBarController viewControllers] objectAtIndex:1]) addView:[app.city count]-1];
     [((weatherWeakViewController*)[[app.tabBarController viewControllers] objectAtIndex:2]) addView:[app.city count]-1];

    //[self.tableView beginUpdates];
    [app refresh:city.tags];
  //  [self.tableView endUpdates];
}
-(void) ReloadList
{
    [tableView reloadData];
    [self.citylist dismissModalViewControllerAnimated:YES];
}


@end
