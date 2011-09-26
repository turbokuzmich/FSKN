//
//  MagazineRootViewController.m
//  FSKN 2
//
//  Created by Дмитрий Куртеев on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MagazineRootViewController.h"
#import "PublicationController.h"
#import "FSKN_2AppDelegate.h"

@implementation MagazineRootViewController

@synthesize localPublications = _localPublications;
@synthesize titleFont = _titleFont, urlFont = _urlFont;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    self.navigationController.toolbarHidden = NO;
    
    [self updateLocalPublications];
    
    _titleFont = [[UIFont fontWithName:@"Georgia" size:20.0f] retain];
    _urlFont   = [[UIFont fontWithName:@"Verdana" size:10.0f] retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    _localPublications = nil;
    _titleFont = nil;
    _urlFont = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)dealloc
{
    [_localPublications release];
    [_titleFont release];
    [_urlFont release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_localPublications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *cellData = (NSDictionary *)[self.localPublications objectAtIndex:indexPath.row];
    NSString *title = [cellData valueForKey:@"title"];
    NSString *url = [cellData valueForKey:@"url"];
    
    CGSize titleSize = [title sizeWithFont:self.titleFont forWidth:MAXFLOAT lineBreakMode:UILineBreakModeTailTruncation];
    CGSize urlSize = [url sizeWithFont:self.urlFont forWidth:MAXFLOAT lineBreakMode:UILineBreakModeTailTruncation];
    
    CGRect titleRect = CGRectMake(5.0f, 2.0f, 280.0f, titleSize.height);
    CGRect urlRect = CGRectMake(5.0f, titleSize.height + 5.0f, 280.0f, urlSize.height);
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:titleRect] autorelease];
    UILabel *urlLabel = [[[UILabel alloc] initWithFrame:urlRect] autorelease];
    
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.font = self.titleFont;
    titleLabel.text = title;
    
    urlLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    urlLabel.font = self.urlFont;
    urlLabel.text = url;
    urlLabel.textColor = [UIColor grayColor];
    
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:urlLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([[NSString stringWithString:@"a"] sizeWithFont:self.titleFont forWidth:MAXFLOAT lineBreakMode:UILineBreakModeTailTruncation]).height + ([[NSString stringWithString:@"a"] sizeWithFont:self.urlFont forWidth:MAXFLOAT lineBreakMode:UILineBreakModeTailTruncation]).height + 10.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublicationController *publicationController = [[[PublicationController alloc] initWithNibName:@"PublicationController" bundle:nil] autorelease];
    publicationController.num = [NSNumber numberWithUnsignedInteger:indexPath.row + 1];
    [self.navigationController pushViewController:publicationController animated:YES];
}

- (void)updateLocalPublications
{
    [_localPublications release];
    self.localPublications = [NSMutableArray array];
    
    NSFileManager *df = [NSFileManager defaultManager];
    NSArray *appDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = (NSString *)[appDirs objectAtIndex:0];
    
    NSArray *dirs = [df contentsOfDirectoryAtPath:documentDir error:nil];
    
    for (NSString *dir in dirs) {
        NSString *configPath = [[documentDir stringByAppendingPathComponent:dir] stringByAppendingPathComponent:@"config"];
        if ([df fileExistsAtPath:configPath]) {
            NSString *contents = [NSString stringWithUTF8String:[[df contentsAtPath:configPath] bytes]];
            NSArray *publicationParamsArray = [contents componentsSeparatedByString:@"\n"];
            NSString *publicationName = [publicationParamsArray objectAtIndex:0];
            NSString *publicationUrl = [publicationParamsArray objectAtIndex:1];
            NSDictionary *publicationParams = [NSDictionary dictionaryWithObjectsAndKeys:publicationName, @"title", publicationUrl, @"url", nil];
            [_localPublications addObject:publicationParams];
        }
    }
    
    [(UITableView *)self.view reloadData];
}

@end
