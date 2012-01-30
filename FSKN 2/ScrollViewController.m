//
//  ScrollViewController.m
//  FSKN
//
//  Created by Дмитрий on 17.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollViewController.h"


@implementation ScrollViewController

@synthesize scrollView, statistics1, statistics2, statistics3, statistics4, statistics5, statistics6, statistics7, statistics8, statistics9, statistics10, statistics11, statistics12, statistics13, statistics14, statistics15, statistics16, pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [scrollView release];
    [statistics1 release];
    [statistics2 release];
    [statistics3 release];
    [statistics4 release];
    [statistics5 release];
    [statistics6 release];
    [statistics7 release];
    [statistics8 release];
    [statistics9 release];
    [statistics10 release];
    [statistics11 release];
    [statistics12 release];
    [statistics13 release];
    [statistics14 release];
    [statistics15 release];
    [statistics16 release];
    [pageControl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    pagingIsEnabled = NO;
    
    [super viewDidLoad];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    
    CGRect size = CGRectMake(0.0, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.statistics1.frame = size;
    self.statistics2.frame = CGRectMake(size.size.width, 0.0f, size.size.width, size.size.height);
    self.statistics3.frame = CGRectMake(size.size.width * 2, 0.0f, size.size.width, size.size.height);
    self.statistics4.frame = CGRectMake(size.size.width * 3, 0.0f, size.size.width, size.size.height);
    self.statistics5.frame = CGRectMake(size.size.width * 4, 0.0f, size.size.width, size.size.height);
    self.statistics6.frame = CGRectMake(size.size.width * 5, 0.0f, size.size.width, size.size.height);
    self.statistics7.frame = CGRectMake(size.size.width * 6, 0.0f, size.size.width, size.size.height);
    self.statistics8.frame = CGRectMake(size.size.width * 7, 0.0f, size.size.width, size.size.height);
    self.statistics9.frame = CGRectMake(size.size.width * 8, 0.0f, size.size.width, size.size.height);
    self.statistics10.frame = CGRectMake(size.size.width * 9, 0.0f, size.size.width, size.size.height);
    self.statistics11.frame = CGRectMake(size.size.width * 10, 0.0f, size.size.width, size.size.height);
    self.statistics12.frame = CGRectMake(size.size.width * 11, 0.0f, size.size.width, size.size.height);
    self.statistics13.frame = CGRectMake(size.size.width * 12, 0.0f, size.size.width, size.size.height);
    self.statistics14.frame = CGRectMake(size.size.width * 13, 0.0f, size.size.width, size.size.height);
    self.statistics15.frame = CGRectMake(size.size.width * 14, 0.0f, size.size.width, size.size.height);
    self.statistics16.frame = CGRectMake(size.size.width * 15, 0.0f, size.size.width, size.size.height);
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 16, self.scrollView.frame.size.height);
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    self.statistics1 = nil;
    self.statistics2 = nil;
    self.statistics3 = nil;
    self.statistics4 = nil;
    self.statistics5 = nil;
    self.statistics6 = nil;
    self.statistics7 = nil;
    self.statistics8 = nil;
    self.statistics9 = nil;
    self.statistics10 = nil;
    self.statistics11 = nil;
    self.statistics12 = nil;
    self.statistics13 = nil;
    self.statistics14 = nil;
    self.statistics15 = nil;
    self.statistics16 = nil;
    self.pageControl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.scrollView addSubview:self.statistics1];
    [self.scrollView addSubview:self.statistics2];
    [self.scrollView addSubview:self.statistics3];
    [self.scrollView addSubview:self.statistics4];
    [self.scrollView addSubview:self.statistics5];
    [self.scrollView addSubview:self.statistics6];
    [self.scrollView addSubview:self.statistics7];
    [self.scrollView addSubview:self.statistics8];
    [self.scrollView addSubview:self.statistics9];
    [self.scrollView addSubview:self.statistics10];
    [self.scrollView addSubview:self.statistics11];
    [self.scrollView addSubview:self.statistics12];
    [self.scrollView addSubview:self.statistics13];
    [self.scrollView addSubview:self.statistics14];
    [self.scrollView addSubview:self.statistics15];
    [self.scrollView addSubview:self.statistics16];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.statistics1 removeFromSuperview];
    [self.statistics2 removeFromSuperview];
    [self.statistics3 removeFromSuperview];
    [self.statistics4 removeFromSuperview];
    [self.statistics5 removeFromSuperview];
    [self.statistics6 removeFromSuperview];
    [self.statistics7 removeFromSuperview];
    [self.statistics8 removeFromSuperview];
    [self.statistics9 removeFromSuperview];
    [self.statistics10 removeFromSuperview];
    [self.statistics11 removeFromSuperview];
    [self.statistics12 removeFromSuperview];
    [self.statistics13 removeFromSuperview];
    [self.statistics14 removeFromSuperview];
    [self.statistics15 removeFromSuperview];
    [self.statistics16 removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pagingIsEnabled) {
        CGFloat width = self.scrollView.frame.size.width;
        self.pageControl.currentPage = floor((self.scrollView.contentOffset.x - width / 2) / width) + 1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    pagingIsEnabled = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
{
    pagingIsEnabled = NO;
}

- (IBAction)pageDidChange
{
    pagingIsEnabled = YES;
    CGPoint offset = CGPointMake(self.pageControl.currentPage * self.scrollView.frame.size.width, 0.0);
    [self.scrollView setContentOffset:offset animated:YES];
}

@end
