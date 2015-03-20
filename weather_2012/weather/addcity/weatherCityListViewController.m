//
//  weatherCityListViewController.m
//  zaweather
//
//  Created by duangl on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherCityListViewController.h"
#import "weatherAppDelegate.h"
#import "POAPinyin.h"
#import "XCell.h"
@interface weatherCityListViewController ()

@end

@implementation weatherCityListViewController
@synthesize leftBtn,background,delegate,table,indexArray,rightBtn,selectedDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate];  
    selectNum = [app.city count];
    self.selectedDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];

    NSMutableDictionary * dict = nil;
    self.background.image = GetImage([app.backgroundAddCity objectAtIndex:[[app.city objectAtIndex:app.currentCityIndex] bgID]]);
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_1",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_2",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateHighlighted]; 
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_1",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_2",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateHighlighted]; 
    for (int i =0 ;i< [[app sourceData] count];i++) 
    {
        dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSString * first = [POAPinyin convertSingle:[[app.sourceData objectAtIndex:i] objectForKey:@"name"]];
        [dict setValue:[NSNumber numberWithInt:i] forKey:@"id"];
        [dict setValue:first forKey:@"first"];
        [dict setValue:[NSString stringWithFormat:@"%@ %@",first,[[app.sourceData objectAtIndex:i] objectForKey:@"name"]] forKey:@"title"];
        [dict setValue:[NSNumber numberWithInt:[[[app.sourceData objectAtIndex:i] objectForKey:@"citys"] count]] forKey:@"count"];
        [array addObject:dict];
        [dict release];
    }
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"first" ascending:YES]; 
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1]; 
    self.indexArray = [[NSMutableArray alloc] initWithArray:[array sortedArrayUsingDescriptors:sortDescriptors]];
    [sorter release];
    [array release];
    
    dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setValue:[NSNumber numberWithInt:-1] forKey:@"id"];
    [dict setValue:@"#" forKey:@"first"];
    [dict setValue:@"PM2.5" forKey:@"title"];
    [dict setValue:[NSNumber numberWithInt:[app.pm25city count]] forKey:@"count"];
    [self.indexArray insertObject:dict atIndex:0];
    [dict release];
    
}

- (void)viewDidUnload
{
    [self.indexArray removeAllObjects];
    [self.indexArray release];
    [self.selectedDict removeAllObjects];
    [self.selectedDict release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate];  

    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [[[self.indexArray objectAtIndex:section] objectForKey:@"count"] intValue];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate];  

    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(0, 0, tableView.bounds.size.width, 22);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    label.text = [[self.indexArray objectAtIndex:section] objectForKey:@"title"];
    
    // Create header view and add label as a subview
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)] autorelease];
//    [sectionView setBackgroundColor:[app.textColor objectAtIndex:((weatherCityData*)[app.city objectAtIndex:app.currentCityIndex]).bgID]];
    [sectionView setBackgroundColor:[UIColor colorWithRed:113/255.0f green:113/255.0f blue:113/255.0f alpha:1]];
    [sectionView addSubview:label];
    return sectionView; 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(UIView *view in [tableView subviews])
    {
        if([[[view class] description] isEqualToString:@"UITableViewIndex"])
        {
            [view setBackgroundColor:[UIColor clearColor]];
            [view setAlpha:0.5];
        }
    }
    static NSString *CellIdentifier = @"XCell";
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate];  
    int bgid = ((weatherCityData*)[app.city objectAtIndex:app.currentCityIndex]).bgID;

//    int num = 0;
//    for (int i=0; i<indexPath.section; i++) {
//        num += [[[self.indexArray objectAtIndex:i] objectForKey:@"count"] intValue];
//    }
//    num += indexPath.row;
//    NSLog(@"%d",num);
    XCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 

        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.isselect.image = [UIImage imageNamed:@"selected"];
        cell.noselect.image = [UIImage imageNamed:[NSString stringWithFormat:@"select%d",bgid+1]];
        cell.image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"tag1_%d",bgid+1]];
        cell.image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"tag2_%d",bgid+1]];
    } 
    int numID = [[[self.indexArray objectAtIndex:indexPath.section] objectForKey:@"id"] intValue];
    if(numID == -1)
    {
        cell.index1 = [[[app.pm25city objectAtIndex:indexPath.row] objectForKey:@"index1"] intValue];
        cell.index2 = [[[app.pm25city objectAtIndex:indexPath.row] objectForKey:@"index2"] intValue];
        cell.title.text = [[app.pm25city objectAtIndex:indexPath.row] objectForKey:@"name"];

    }else if(numID == -2)
    {
        
    }
    else
    {
        cell.index1 = [[[self.indexArray objectAtIndex:indexPath.section] objectForKey:@"id"] intValue];
        cell.index2 = indexPath.row;
        cell.title.text = [[[[app.sourceData objectAtIndex:cell.index1] objectForKey:@"citys"] objectAtIndex:cell.index2] objectForKey:@"name"];
    }
    [cell.image1 setHidden:YES];
    [cell.image2 setHidden:YES];
    id pm25 = [app.cityConfig objectForKey:cell.title.text];
    if(pm25)
    {
        switch ([pm25 intValue]) {
            case 2:
            {
                [cell.image1 setHidden:NO];
            }
            case 1:
            {
                [cell.image2 setHidden:NO];
            }
                break;
            default:
            {
                [cell.image1 setHidden:YES];
                [cell.image2 setHidden:YES];
            }
                break;
        }
    }
    else {
        [cell.image1 setHidden:YES];
        [cell.image2 setHidden:YES];
    }
    
    // Configure the cell...
    bool isShow = false;
    for (weatherCityData * city in app.city) 
    {
        if([city.cityName isEqual:cell.title.text])
        {
            isShow = true;
            break;
        }
    }
    if(isShow)
    {
        [cell.isselect setHidden:NO];
    }
    else 
    {
        [cell.isselect setHidden:YES];
    }
    
    if([selectedDict objectForKey:cell.title.text])
    {
        [cell.noselect setHidden:NO];
    }
    else 
    {
        [cell.noselect setHidden:YES];
    }
//    if(indexPath.section == 0)
//    {
//        for (XCell* xcell in tableView.visibleCells) 
//        {
//            if([xcell.title.text isEqual:cell.title.text])
//            {
//                [xcell.noselect setHidden:cell.noselect.hidden];
//            }
//        }
//    }
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate];  
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (int i=0;i<[self.indexArray count];i++) 
    {
        id ind = [self.indexArray objectAtIndex:i];
        if([[ind objectForKey:@"id"] intValue] < 0)
        {
            [array addObject:@"#"];
        }
        else if(![[ind objectForKey:@"first"] isEqual:[array lastObject]])
        {
            [array addObject:[ind objectForKey:@"first"]];
        }
    }
    return array;
}// return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if([title isEqual:@"PM2.5"])
        return 0;
    for (int i=0; i<[self.indexArray count]; i++) 
    {
        if([[[self.indexArray objectAtIndex:i] objectForKey:@"first"] isEqual:title])
        {
            return i;
        }
    }
    return 0;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate];  
    int bgid = ((weatherCityData*)[app.city objectAtIndex:app.currentCityIndex]).bgID;
    XCell *cell= (XCell*)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.isselect.hidden)
    {
        if(cell.noselect.hidden)
        {
            if([self.selectedDict count] + selectNum == 10)
            {
                [[[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多添加十个城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease] show];
            }
            else 
            {
                
                [selectedDict setValue:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:cell.index1],@"index1",[NSNumber numberWithInt:cell.index2],@"index2", nil] forKey:cell.title.text];
                [cell.noselect setHidden:NO];
            }
        }
        else 
        {
            [self.selectedDict removeObjectForKey:cell.title.text];
            [cell.noselect setHidden:YES];
        }
    }
    if(indexPath.section == 0)
    {
        for (XCell* xcell in tableView.visibleCells) 
        {
            if([xcell.title.text isEqual:cell.title.text])
            {
                [xcell.noselect setHidden:cell.noselect.hidden];
            }
        }
    }
//    [delegate AddCityWithIndex1:[[[self.indexArray objectAtIndex:indexPath.section] objectForKey:@"id"] intValue]  WithIndex2:indexPath.row];
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(IBAction) ClickLeft:(id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction) ClickRight:(id) sender
{
    for (id dict in [selectedDict allValues]) 
    {
       [delegate AddCityWithIndex1:[[dict objectForKey:@"index1"] intValue]  WithIndex2:[[dict objectForKey:@"index2"] intValue]];
    }
    [selectedDict removeAllObjects];
    [delegate ReloadList];

}

-(void) otherData
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate];  

}


@end
