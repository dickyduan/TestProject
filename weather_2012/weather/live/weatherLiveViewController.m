//
//  weatherLiveViewController.m
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherLiveViewController.h"
#import "weatherLiveSubViewController.h"
#import "weatherAppDelegate.h"

@implementation weatherLiveViewController

@synthesize scrollView;
@synthesize subViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"生活指数";
        self.tabBarItem.image = [UIImage imageNamed:@"baricon_3"];
        
        subViewController = [[NSMutableArray alloc] initWithCapacity:0];
        weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
        
        for (int i=0; i<[app.city count]; i++) 
        {
            weatherLiveSubViewController *sub = [[[weatherLiveSubViewController alloc] initWithNibName:@"weatherLiveSubViewController" bundle:nil] autorelease];
            sub.data = [app.city objectAtIndex:i];
            sub.view.frame = CGRectMake(i*320, 0, 320, 411);
            [subViewController addObject:sub];
            [self.view addSubview:sub.view];
            
        }
        
        int pagesCount = [app.city count];
        pageControl = [[XPageControl alloc] init];
        pageControl.center = CGPointMake(self.view.frame.size.width/2, 347-10);//设置pageControl的位置
        
        pageControl.numberOfPages = pagesCount;
        [pageControl setImagePageStateNormal:[UIImage imageNamed:@"dian2"]];
        [pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"dian"]];
        [pageControl setCurrentPage:0];
        
        [pageControl setBounds:CGRectMake(0, 0, 16 * (pagesCount - 1) + 16, 16)];// pageControl上的圆点间距基本在16左右
        [pageControl setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:pageControl];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.directionalLockEnabled = YES;
//    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*[app.city count], scrollView.frame.size.height);  
}
-(void)reloadIndex:(int) index
{
    if(index < [subViewController count])
        [((weatherLiveSubViewController*)[subViewController objectAtIndex:index]) refreshData:nil];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.title = [[NSNumber numberWithInt:[subViewController count]] stringValue];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated    // Called when the view is about to made visible. Default does nothing
{
    for (weatherLiveSubViewController * sub in subViewController) {
        [sub loadBG];
    }//    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
//    
//    if(app.currentCityIndex>0)
//        [[subViewController objectAtIndex:app.currentCityIndex-1] loadBG];
//    
//    [[subViewController objectAtIndex:app.currentCityIndex] loadBG];
//    
//    if(app.currentCityIndex+1<[subViewController count])
//        [[subViewController objectAtIndex:app.currentCityIndex+1] loadBG];
    
}
- (void)viewDidDisappear:(BOOL)animated  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
    for (weatherLiveSubViewController * sub in subViewController) {
        [sub clearBG];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)deleteView:(int) index
{
    [((weatherLiveSubViewController*)[subViewController objectAtIndex:index]).view removeFromSuperview];
    [subViewController removeObjectAtIndex:index];
    
    for (int i=0; i<[subViewController count]; i++) 
    {
        ((weatherLiveSubViewController*)[subViewController objectAtIndex:i]).view.frame = CGRectMake(i*320, 0, 320, 411);
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*[subViewController count], scrollView.frame.size.height);  
    
    [pageControl removeFromSuperview];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*[subViewController count], scrollView.frame.size.height);  
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    pageControl.numberOfPages = [app.city count];
    [pageControl setBounds:CGRectMake(0, 0, 16 * ([pageControl numberOfPages] - 1) + 16, 16)];
    [self.view addSubview:pageControl];
}
-(void)addView:(int) index
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    
    weatherLiveSubViewController *sub = [[[weatherLiveSubViewController alloc] initWithNibName:@"weatherLiveSubViewController" bundle:nil] autorelease];
    sub.data = [app.city objectAtIndex:index];

    [subViewController addObject:sub];
    [self.view addSubview:sub.view];
    
    for (int i=0; i<[subViewController count]; i++) 
    {
        ((weatherLiveSubViewController*)[subViewController objectAtIndex:i]).view.frame = CGRectMake(i*320, 0, 320, 411);
    }
    [pageControl removeFromSuperview];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*[subViewController count], scrollView.frame.size.height);  
    
    pageControl.numberOfPages = [app.city count];
    [pageControl setBounds:CGRectMake(0, 0, 16 * ([pageControl numberOfPages] - 1) + 16, 16)];
    [self.view addSubview:pageControl];

    
}
-(void)refreshLastTimer
{
    for (weatherLiveSubViewController* subview in subViewController) {
        [subview refreshLastTimer];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    if((int)(scrollView.contentOffset.x)%320 == 0)
    {
        int newIndex = scrollView.contentOffset.x/320;
        
//        if(newIndex>app.currentCityIndex)
//        {
//            if(app.currentCityIndex > 0)
//                [[subViewController objectAtIndex:app.currentCityIndex-1] clearBG];
//            if(newIndex+1<[subViewController count])
//                [[subViewController objectAtIndex:newIndex+1] loadBG];
//        }else if(newIndex<app.currentCityIndex)
//        {
//            if(newIndex > 0)
//                [[subViewController objectAtIndex:newIndex-1] clearBG];
//            if(app.currentCityIndex+1<[subViewController count])
//                [[subViewController objectAtIndex:app.currentCityIndex+1] loadBG];
//        }
        app.currentCityIndex = newIndex;
        [pageControl setCurrentPage:newIndex];
    }
    pageControl.center = CGPointMake(160 + self.scrollView.contentOffset.x, 347-10);//设置pageControl的位置
}
@end
