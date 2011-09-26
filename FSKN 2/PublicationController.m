//
//  PublicationController.m
//  FSKN 2
//
//  Created by Дмитрий Куртеев on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PublicationController.h"

@implementation PublicationController

@synthesize num;

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
    
    ((UIScrollView *)self.view).contentSize = CGSizeMake(pagesCount * self.view.bounds.size.width, self.view.bounds.size.height);
    ((UIScrollView *)self.view).bounces = NO;
    ((UIScrollView *)self.view).pagingEnabled = YES;
    
    for (int i = 0; i < pagesCount; i++) {
        UIWebView *newWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(i * self.view.bounds.size.width, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height)] autorelease];
        
        NSString *path = [(NSString *)[filesArray objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *newRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
        [newWebView loadRequest:newRequest];
        
        [self.view addSubview:newWebView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.num = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSMutableArray *webViews = [NSMutableArray array];
    for (id subview in self.view.subviews) {
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

- (void)dealloc
{
    [num release];
    [super dealloc];
}

@end
