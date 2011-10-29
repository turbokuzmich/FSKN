//
//  PublicationController.m
//  FSKN 2
//
//  Created by Дмитрий Куртеев on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PublicationController.h"

BOOL buttonsHidden = YES;
BOOL isMoving = NO;

@implementation PublicationController

@synthesize scrollView = _scrollView;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize num;
@synthesize webViewsToObserve;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.webViewsToObserve = [NSMutableArray array];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSArray *appDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *searchDirectory = (NSString *)[appDirs objectAtIndex:0];
    NSMutableArray *filesArray = [NSMutableArray array];
    
    int i = 0;
    while (YES) {
        i++;
        
        NSString *supposedFilePath = [NSString stringWithFormat:@"%@/%@/%d.html", searchDirectory, num, i];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:supposedFilePath];
        
        if (!fileExists) {
            break;
        } else {
            [filesArray addObject:supposedFilePath];
        }
    }
    
    NSUInteger pagesCount = [filesArray count];
    
    if (pagesCount == 0) return;
    
    (self.scrollView).contentSize = CGSizeMake(pagesCount * self.view.bounds.size.width, self.view.bounds.size.height);
    (self.scrollView).pagingEnabled = YES;
    
    for (int i = 0; i < pagesCount; i++) {
        UIWebView *newWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(i * self.view.bounds.size.width, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height)] autorelease];
        
        NSString *path = [(NSString *)[filesArray objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *newRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
        [newWebView loadRequest:newRequest];
        
        [self.scrollView addSubview:newWebView];
        [self.webViewsToObserve addObject:newWebView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.leftButton = nil;
    self.rightButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSMutableArray *webViews = [NSMutableArray array];
    for (id subview in self.scrollView.subviews) {
        if ([subview isKindOfClass:[UIWebView class]]) {
            [webViews addObject:subview];
        }
    }
    
    NSUInteger pagesCount = [webViews count];
    ((UIScrollView *)self.view).contentSize = CGSizeMake(pagesCount * self.view.bounds.size.width, self.view.bounds.size.height);
    
    for (int i = 0; i < pagesCount; i++) {
        [(UIWebView *)[webViews objectAtIndex:i] setFrame:CGRectMake(i * self.view.bounds.size.width, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isMoving = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isMoving = NO;
    
    CGFloat frameWidth = self.scrollView.frame.size.width;
    CGFloat offset = self.scrollView.contentOffset.x;
    CGFloat contentWidth = self.scrollView.contentSize.width;
    
    if (!buttonsHidden) {
        if (offset == 0.0f) {
            self.leftButton.hidden = YES;
            self.rightButton.hidden = NO;
        } else if (contentWidth - offset == frameWidth) {
            self.leftButton.hidden = NO;
            self.rightButton.hidden = YES;
        } else {
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)userDidTapWebView
{
    if (buttonsHidden) {
        CGFloat frameWidth = self.scrollView.frame.size.width;
        CGFloat offset = self.scrollView.contentOffset.x;
        CGFloat contentWidth = self.scrollView.contentSize.width;
        
        if (offset == 0.0f) {
            self.leftButton.hidden = YES;
            self.rightButton.hidden = NO;
        } else if (contentWidth - offset == frameWidth) {
            self.leftButton.hidden = NO;
            self.rightButton.hidden = YES;
        } else {
            self.leftButton.hidden = NO;
            self.rightButton.hidden = NO;
        }
    } else {
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
    }
    
    buttonsHidden = !buttonsHidden;
}

- (void)left:(id)sender
{
    if (!isMoving) {
        CGFloat frameWidth = self.scrollView.frame.size.width;
        CGFloat offset = self.scrollView.contentOffset.x;
        
        CGPoint to = CGPointMake(offset - frameWidth, 0.0f);
        [self.scrollView setContentOffset:to animated:YES];
        
        isMoving = YES;
    }
}

- (void)right:(id)sender
{
    if (!isMoving) {
        CGFloat frameWidth = self.scrollView.frame.size.width;
        CGFloat offset = self.scrollView.contentOffset.x;
        
        CGPoint to = CGPointMake(offset + frameWidth, 0.0f);
        [self.scrollView setContentOffset:to animated:YES];
        
        isMoving = YES;
    }
}


@end
