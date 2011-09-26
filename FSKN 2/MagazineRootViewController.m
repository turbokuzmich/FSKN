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
#import "SSZipArchive.h"
#import "Reachability.h"

BOOL publicationsLoadingInProgress = NO;
NSURLConnection *publicationsXmlConnection;      // соединение по получению xml с сервера
NSMutableData *publicationsXmlData;              // данные, полученные с сервера (потом парсятся как xml)
NSMutableArray *remotePublicationList;           // массив из объектов публикаций
NSMutableDictionary *currentRemotePublication;   // текущая публикация
NSString* currentRemotePublicationPropertyName;  // текущее свойство публикации
NSString* currentRemotePublicationPropertyValue; // текущее значение текущего свойства
NSMutableArray *missingPublications;             // отсутствующие локально публикации (список их айдишников)
NSMutableArray *publicationDownloadConnections;  // массив открытых соединений по скачиванию журналов
NSMutableArray *publicationDownloadData;         // массив полученных данных скачиваемых публикаций
int missingCount = 0;

@implementation MagazineRootViewController

@synthesize localPublications = _localPublications;
@synthesize wantPublicationsButton = _wantPublicationsButton;
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
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.wantPublicationsButton = nil;
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
    [internetReachable release];
    [publicationsXmlConnection release];
    [publicationsXmlData release];
    [remotePublicationList release];
    [currentRemotePublication release];
    [currentRemotePublicationPropertyName release];
    [currentRemotePublicationPropertyValue release];
    [missingPublications release];
    [publicationDownloadConnections release];
    [publicationDownloadData release];
    [_wantPublicationsButton release];
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



- (BOOL)checkNetworkStatus
{
    if (publicationsLoadingInProgress) return NO;
    
    BOOL internetOk = NO;
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus) {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            internetOk = YES;
            break;
            
        default:
            internetOk = NO;
            break;
    }
    
    return internetOk;
}



- (void)loadPublicationsXml
{
    publicationsLoadingInProgress = YES;
    
    NSURL *publicationsXmlUrl = [NSURL URLWithString:@"http://dima2.local.crmm.ru/publications.list.xml"];
    NSURLRequest *publicationsXmlRequest = [NSURLRequest requestWithURL:publicationsXmlUrl];
    publicationsXmlConnection = [[NSURLConnection alloc] initWithRequest:publicationsXmlRequest delegate:self];
    publicationsXmlData = [[NSMutableData alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"publications"]) {
        if (!remotePublicationList) {
            remotePublicationList = [[NSMutableArray alloc] init];
        }
    } else if([elementName isEqualToString:@"item"]) {
        currentRemotePublication = [[NSMutableDictionary alloc] init];
    } else {
        currentRemotePublicationPropertyName = elementName;
        [currentRemotePublicationPropertyName retain];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentRemotePublicationPropertyValue = string;
    [currentRemotePublicationPropertyValue retain];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"publications"]) {
        // вроде закончили
    } else if ([elementName isEqualToString:@"item"]) {
        [remotePublicationList addObject:currentRemotePublication];
        [currentRemotePublication release];
    } else {
        [currentRemotePublication setObject:currentRemotePublicationPropertyValue forKey:currentRemotePublicationPropertyName];
        [currentRemotePublicationPropertyName release];
        [currentRemotePublicationPropertyValue release];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [parser release];
    
    [self showStatusWithMessage:@"Разбор завершен. Сравниваю с локальным списком."];
    
    [self checkLocalPublicationsList];
}

- (void)checkLocalPublicationsList
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [directories objectAtIndex:0];
    
    for (id publicationData in remotePublicationList) {
        NSString *ID = (NSString *)[(NSDictionary *)publicationData objectForKey:@"id"];
        NSString *localPublicationPath = [documentDirectoryPath stringByAppendingPathComponent:ID];
        
        BOOL publicationExists = [[NSFileManager defaultManager] fileExistsAtPath:localPublicationPath isDirectory:nil];
        if (!publicationExists) {
            missingCount++;
            if (!missingPublications) {
                missingPublications = [[NSMutableArray alloc] init];
            }
            [missingPublications addObject:ID];
        }
    }
    
    if (missingCount) {
        NSString *message = @"Отсутствующих публикаций: %i. Скачиваю.";
        message = [NSString stringWithFormat:message, missingCount];
        
        [self showStatusWithMessage:message];
        
        [self downloadMissingPublications];
    } else {
        [self showStatusWithMessage:@"Все публикации скачены."];
        [self disableWantPublicationsButton];
        publicationsLoadingInProgress = NO;
    }
    
    
}

- (void)downloadMissingPublications
{
    NSString *pathPrefix = @"http://dima2.local.crmm.ru/publications/%@.zip";
    
    for (id ID in missingPublications) {
        NSString *remotePathString = [NSString stringWithFormat:pathPrefix, ID];
        NSURL *remotePath = [NSURL URLWithString:remotePathString];
        NSURLRequest *remoteRequest = [NSURLRequest requestWithURL:remotePath];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:remoteRequest delegate:self];
        
        if (!publicationDownloadConnections) {
            publicationDownloadConnections = [[NSMutableArray alloc] init];
        }
        
        [publicationDownloadConnections addObject:connection];
        
        if (!publicationDownloadData) {
            publicationDownloadData = [[NSMutableArray alloc] init];
        }
        NSMutableData *data = [NSMutableData data];
        [data setLength:0];
        [publicationDownloadData addObject:data];
    }
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connection == publicationsXmlConnection) {
        [self showStatusWithMessage:@"Не удалось получить список публикаций"];
        
        [publicationsXmlConnection release];
        [publicationsXmlData release];
    } else {
        NSUInteger connectionIndex = [publicationDownloadConnections indexOfObjectIdenticalTo:connection];
        if (connectionIndex != NSNotFound) {
            [self showStatusWithMessage:[NSString stringWithFormat:@"Не удалось загрузить публикацию %@.", [missingPublications objectAtIndex:connectionIndex]]];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == publicationsXmlConnection) {
        [publicationsXmlData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == publicationsXmlConnection) {
        [publicationsXmlData appendData:data];
    } else {
        NSUInteger connectionIndex = [publicationDownloadConnections indexOfObjectIdenticalTo:connection];
        if (connectionIndex != NSNotFound) {
            NSMutableData *d = [publicationDownloadData objectAtIndex:connectionIndex];
            [d appendData:data];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == publicationsXmlConnection) {
        [publicationsXmlConnection release];
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:publicationsXmlData];
        [publicationsXmlData release];
        
        [self showStatusWithMessage:@"Список получен. Разбираю."];
        [parser setDelegate:self];
        [parser parse];
    } else {
        NSUInteger connectionIndex = [publicationDownloadConnections indexOfObjectIdenticalTo:connection];
        
        if (connectionIndex != NSNotFound) {
            NSMutableData *data = [publicationDownloadData objectAtIndex:connectionIndex];
            NSString *ID = [missingPublications objectAtIndex:connectionIndex];
            
            NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectoryPath = [directories objectAtIndex:0];
            NSString *zipDestination = [[documentDirectoryPath stringByAppendingPathComponent:ID] stringByAppendingString:@".zip"];
            
            [[NSFileManager defaultManager] createFileAtPath:zipDestination contents:data attributes:nil];
            
            NSString *folderDestination = [documentDirectoryPath stringByAppendingPathComponent:ID];
            [SSZipArchive unzipFileAtPath:zipDestination toDestination:folderDestination];
            
            [[NSFileManager defaultManager] removeItemAtPath:zipDestination error:nil];
            
            missingCount--;
            
            if (missingCount == 0) {
                [self showStatusWithMessage:@"Все публикации скачены."];
                
                publicationsLoadingInProgress = NO;
                
                [self disableWantPublicationsButton];
                
                [self updateLocalPublications];
            }
        }
    }
}



- (void)showStatusWithMessage:(NSString *)message
{
    
    NSLog(@"%@", message);
}



- (void)wantsPublications:(id)sender
{
    BOOL hasInternet = [self checkNetworkStatus];
    if (hasInternet) {
        _wantPublicationsButton.title = @"Публикации скачиваются...";
        _wantPublicationsButton.enabled = NO;
        [self loadPublicationsXml];
        [self showStatusWithMessage:@"Есть подключение. Получаю список публикаций."];
    } else {
        [self showStatusWithMessage:@"Доступ в интернет отсутствует."];
        _wantPublicationsButton.title = @"Отсутствует доступ в Интернет";
        _wantPublicationsButton.enabled = NO;
        [self performSelector:@selector(restoreWantPublicationsButton) withObject:self afterDelay:3.0f];
    }
}

- (void)disableWantPublicationsButton
{
    _wantPublicationsButton.title = @"Все публикации скачены";
    _wantPublicationsButton.enabled = NO;
    
    [self performSelector:@selector(restoreWantPublicationsButton) withObject:self afterDelay:3.0f];
}


- (void)restoreWantPublicationsButton
{
    _wantPublicationsButton.enabled = YES;
    _wantPublicationsButton.title = @"Обновить список журналов";
}

@end
