//
//  weatherWeakViewController.m
//  weather
//
//  Created by duangl on 12-2-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherWeakViewController.h"
#import "weatherAppDelegate.h"
#import "weatherWeakSubViewController.h"

@implementation weatherWeakViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize subViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"本周天气";
        self.tabBarItem.image = [UIImage imageNamed:@"baricon_2"];
        
        subViewController = [[NSMutableArray alloc] initWithCapacity:0];
        [self create];

    }
    return self;
}
-(void)create
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    
    for (int i=0; i<[app.city count]; i++) 
    {
        weatherWeakSubViewController *weak = [[weatherWeakSubViewController alloc] initWithNibName:@"weatherWeakSubViewController" bundle:nil] ;
        weak.data = [app.city objectAtIndex:i];
        weak.view.frame = CGRectMake(i*320, 0, 320, 411);
        [subViewController addObject:weak];
        [weak release];
        [self.view addSubview:weak.view];
    }
    pageControl = [[XPageControl alloc] init];
    pageControl.center = CGPointMake(self.view.frame.size.width/2, 347-10);//设置pageControl的位置
        
    int pagesCount = [app.city count];
    pageControl.numberOfPages = pagesCount;
    [pageControl setImagePageStateNormal:[UIImage imageNamed:@"dian2"]];
    [pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"dian"]];
    [pageControl setCurrentPage:0];
    
    [pageControl setBounds:CGRectMake(0, 0, 16 * (pagesCount - 1) + 16, 16)];// pageControl上的圆点间距基本在16左右
    [pageControl setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:pageControl];
}
-(void)remove
{
    for (id subcontroller in subViewController) {
        [[subcontroller view] removeFromSuperview]; 
    }
    [subViewController removeAllObjects];
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
        [((weatherWeakSubViewController*)[subViewController objectAtIndex:index]) refreshData:nil];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    [self remove];
//    self.title = [[NSNumber numberWithInt:[subViewController count]] stringValue];

}
- (void)viewWillAppear:(BOOL)animated    // Called when the view is about to made visible. Default does nothing
{
    for (weatherWeakViewController * sub in subViewController) {
        [sub loadBG];
    }
//    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
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
    for (weatherWeakSubViewController * sub in subViewController) {
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
    [((weatherWeakSubViewController*)[subViewController objectAtIndex:index]).view removeFromSuperview];
    [subViewController removeObjectAtIndex:index];
    
    for (int i=0; i<[subViewController count]; i++) 
    {
        ((weatherWeakSubViewController*)[subViewController objectAtIndex:i]).view.frame = CGRectMake(i*320, 0, 320, 411);
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*[subViewController count], scrollView.frame.size.height);  
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    pageControl.numberOfPages = [app.city count];
    if(pageControl.currentPage >= [app.city count])
        [pageControl setCurrentPage:[app.city count]-1];
    
    [pageControl setBounds:CGRectMake(0, 0, 16 * ([pageControl numberOfPages]- 1) + 16, 16)];

}

-(void)addView:(int) index
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    
    weatherWeakSubViewController *weak = [[[weatherWeakSubViewController alloc] initWithNibName:@"weatherWeakSubViewController" bundle:nil] autorelease];
    weak.data = [app.city objectAtIndex:index];
    [subViewController addObject:weak];
    [self.view addSubview:weak.view];
    
    
    for (int i=0; i<[subViewController count]; i++) 
    {
        ((weatherWeakSubViewController*)[subViewController objectAtIndex:i]).view.frame = CGRectMake(i*320, 0, 320, 411);
    }   
    
    [pageControl removeFromSuperview];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*[subViewController count], scrollView.frame.size.height);  
    
    pageControl.numberOfPages = [app.city count];
    [pageControl setBounds:CGRectMake(0, 0, 16 * ([pageControl numberOfPages] - 1) + 16, 16)];
    [self.view addSubview:pageControl];
}
-(void)refreshLastTimer
{
    for (weatherWeakSubViewController* subview in subViewController) {
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
