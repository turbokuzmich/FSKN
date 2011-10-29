//
//  ScrollViewController.m
//  FSKN
//
//  Created by Дмитрий on 17.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollViewController.h"


@implementation ScrollViewController

@synthesize scrollView, statistics1, statistics2, statistics3, pageControl;

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
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    
    [self.scrollView addSubview:self.statistics1];
    [self.scrollView addSubview:self.statistics2];
    [self.scrollView addSubview:self.statistics3];
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    self.statistics1 = nil;
    self.statistics2 = nil;
    self.pageControl = nil;
    self.statistics3 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
