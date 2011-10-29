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
#import "DownloaderTableViewCell.h"

BOOL remoteXMLLoading = NO;
NSURLConnection *publicationsXmlConnection = nil;      // соединение по получению xml с сервера
NSMutableData *publicationsXmlData = nil;              // данные, полученные с сервера (потом парсятся как xml)
NSMutableArray *remotePublicationList = nil;           // массив из объектов публикаций
NSMutableDictionary *currentRemotePublication = nil;   // текущая публикация
NSString* currentRemotePublicationPropertyName = nil;  // текущее свойство публикации
NSString* currentRemotePublicationPropertyValue = nil; // текущее значение текущего свойства
NSMutableArray *publicationDownloadConnections = nil;  // массив открытых соединений по скачиванию журналов
NSMutableArray *publicationDownloadIndexPaths = nil;   // массив индекспутей ячеек, для которых идет скачивание
NSMutableArray *publicationDownloadResponses = nil;    // массив NSNumber expected download size ячеек, для которых идет скачивание
NSMutableArray *publicationDownloadData = nil;         // массив полученных данных скачиваемых публикаций
NSMutableDictionary *publicationCoversCache = nil;     // кеш картинок для нескаченных публикаций (ключ — indexPath)

@implementation MagazineRootViewController

@synthesize localPublications = _localPublications;
@synthesize wantPublicationsButton = _wantPublicationsButton;
@synthesize imageLoadOperationQueue;
@synthesize publicationToShow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    // сбрасываем публикацию, которую нужно показать
    publicationToShow = nil;
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
    
    imageLoadOperationQueue = [[NSOperationQueue alloc] init];
    
    // делаем список уже скаченных публикаций
    [self updateLocalPublications];
    
    BOOL hasInternet = [self checkNetworkStatus];
    if (hasInternet) {
        // если есть интернет, то сразу пытаемся загрузить список публикаций из интернета
        [self loadPublicationsXml];
    }
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
    [publicationDownloadConnections release];
    [publicationDownloadData release];
    [imageLoadOperationQueue release];
    [publicationCoversCache release];
    [_wantPublicationsButton release];
    [_localPublications release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = 0;
    if (remotePublicationList == nil) {
        numberOfRows = (int)[self.localPublications count];
    } else {
        numberOfRows = (int)[remotePublicationList count];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    DownloaderTableViewCell *cell = (DownloaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelElements = [[NSBundle mainBundle] loadNibNamed:@"DownloaderTableViewCell" owner:nil options:nil];
        cell = [topLevelElements objectAtIndex:0];
    }
    
    if (remotePublicationList == nil) {
        NSDictionary *cellData = (NSDictionary *)[self.localPublications objectAtIndex:[indexPath row]];
        NSString *ID = [cellData valueForKey:@"id"];
        
        cell.titleLabel.text = (NSString *)[cellData valueForKey:@"title"];
        cell.dateLabel.text = (NSString *)[cellData valueForKey:@"date"];
        
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectoryPath = [directories objectAtIndex:0];
        NSString *coverPath = [[documentDirectoryPath stringByAppendingPathComponent:ID] stringByAppendingPathComponent:@"cover.jpg"];
        NSData *coverData = [NSData dataWithContentsOfFile:coverPath];
        UIImage *coverImage = [UIImage imageWithData:coverData];
        cell.coverView.image = coverImage;
        cell.coverView.hidden = NO;
        cell.readButton.hidden = NO;
    } else {
        NSDictionary *cellData = (NSDictionary *)[remotePublicationList objectAtIndex:[indexPath row]];
        NSString *ID = [cellData valueForKey:@"id"];
        
        BOOL isDownloaded = NO;
        for (NSDictionary *downloadedPub in self.localPublications) {
            if ([(NSString *)[downloadedPub valueForKey:@"id"] isEqualToString:ID]) {
                isDownloaded = YES;
            }
        }
        
        cell.titleLabel.text = (NSString *)[cellData valueForKey:@"title"];
        cell.dateLabel.text = (NSString *)[cellData valueForKey:@"date"];
        
        if (isDownloaded) {
            NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectoryPath = [directories objectAtIndex:0];
            NSString *coverPath = [[documentDirectoryPath stringByAppendingPathComponent:ID] stringByAppendingPathComponent:@"cover.jpg"];
            NSData *coverData = [NSData dataWithContentsOfFile:coverPath];
            UIImage *coverImage = [UIImage imageWithData:coverData];
            cell.coverView.image = coverImage;
            cell.coverView.hidden = NO;
            cell.readButton.hidden = NO;
        } else {
            BOOL isLoading = NO;
            int i = 0;
            for (NSIndexPath *p in publicationDownloadIndexPaths) {
                if (p.row == indexPath.row) {
                    isLoading = YES;
                    break;
                }
                i++;
            }
            
            if (isLoading) {
                float totalSize = [(NSNumber *)[publicationDownloadResponses objectAtIndex:i] floatValue];
                float currentSize = (float)[(NSMutableData *)[publicationDownloadData objectAtIndex:i] length];
                float progress = currentSize / totalSize;
                
                cell.progressView.progress = progress;
                cell.progressView.hidden = NO;
            } else {
                cell.downloadButton.hidden = NO;
                [cell.downloadButton addTarget:self action:@selector(loadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                UIImage *cachedImage = nil;
                if (publicationCoversCache != nil) {
                    for (NSIndexPath *p in publicationCoversCache) {
                        if (p.row == indexPath.row) {
                            cachedImage = [publicationCoversCache objectForKey:p];
                        }
                    }
                }
                
                if (cachedImage == nil) {
                    [self loadImageForCellAtIndex:indexPath withPath:(NSString *)[cellData valueForKey:@"cover"]];
                } else {
                    cell.coverView.image = cachedImage;
                    cell.coverView.hidden = NO;
                }
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *num = nil;
    if (remotePublicationList == nil) {
        num = (NSString *)[(NSDictionary *)[self.localPublications objectAtIndex:[indexPath row]] valueForKey:@"id"];
    } else {
        NSString *ID = (NSString *)[(NSDictionary *)[remotePublicationList objectAtIndex:[indexPath row]] valueForKey:@"id"];
        for (NSDictionary *pub in self.localPublications) {
            if ([[pub valueForKey:@"id"] isEqualToString:ID]) {
                num = ID;
                break;
            }
        }
    }
    
    if (num != nil) {
        [self showPublicationWithID:num];
    }
}



- (void)showPublicationWithID:(NSString *)ID
{
    PublicationController *publicationController = [[[PublicationController alloc] initWithNibName:@"PublicationController" bundle:nil] autorelease];
    publicationController.num = ID;
    [self.navigationController pushViewController:publicationController animated:YES];
}


- (void)updateLocalPublications
{
    self.localPublications = nil;
    self.localPublications = [NSMutableArray array];
    
    NSFileManager *df = [NSFileManager defaultManager];
    NSArray *appDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = (NSString *)[appDirs objectAtIndex:0];
    
    NSArray *dirs = [df contentsOfDirectoryAtPath:documentDir error:nil];
    
    for (NSString *dir in dirs) {
        NSString *configPath = [[documentDir stringByAppendingPathComponent:dir] stringByAppendingPathComponent:@"config"];
        NSString *coverPath = [[documentDir stringByAppendingPathComponent:dir] stringByAppendingPathComponent:@"cover.jpg"];
        if ([df fileExistsAtPath:configPath]) {
            NSString *contents = [NSString stringWithUTF8String:[[df contentsAtPath:configPath] bytes]];
            NSArray *publicationParamsArray = [contents componentsSeparatedByString:@"\n"];
            NSString *publicationName = [publicationParamsArray objectAtIndex:0];
            NSString *publicationDate = [publicationParamsArray objectAtIndex:1];
            
            NSDictionary *publicationParams;
            if ([df fileExistsAtPath:coverPath]) {
                publicationParams = [NSDictionary dictionaryWithObjectsAndKeys:dir, @"id", publicationName, @"title", publicationDate, @"date", coverPath, @"cover", nil];
            } else {
                publicationParams = [NSDictionary dictionaryWithObjectsAndKeys:dir, @"id", publicationName, @"title", publicationDate, @"date", @"", @"cover", nil];
            }
            
            
            [_localPublications addObject:publicationParams];
        }
    }
    
    [self.tableView reloadData];
}



- (BOOL)checkNetworkStatus
{
    BOOL internetOk = NO;
    
    if (internetReachable == nil) {
        internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    }
    
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
    if (!remoteXMLLoading && ![self publicationsAreDownloading]) {
        remoteXMLLoading = YES;
        
        NSURL *publicationsXmlUrl = [NSURL URLWithString:@"http://dima2.local.crmm.ru/publications.list.xml"];
        NSURLRequest *publicationsXmlRequest = [NSURLRequest requestWithURL:publicationsXmlUrl];
        publicationsXmlConnection = [[NSURLConnection alloc] initWithRequest:publicationsXmlRequest delegate:self];
        publicationsXmlData = [[NSMutableData alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"publications"]) {
        if (remotePublicationList != nil) {
            [remotePublicationList release];
        }
        remotePublicationList = [[NSMutableArray alloc] init];
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
    [parser autorelease];
    
    [self showStatusWithMessage:@"Разбор завершен. Перестраиваю таблицу."];
    
    remoteXMLLoading = NO;
    
    [self.tableView reloadData];
    
    [self disableWantPublicationsButton];
    
    // проверяем, хотим ли мы показать журнал с главной страницы
    if (self.publicationToShow != nil) {
        [self loadPublicationWithID:self.publicationToShow];
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
            [self showStatusWithMessage:[NSString stringWithFormat:@"Не удалось загрузить публикацию %d.", connectionIndex]];
            [publicationDownloadConnections removeObjectAtIndex:connectionIndex];
            [publicationDownloadData removeObjectAtIndex:connectionIndex];
            [publicationDownloadIndexPaths removeObjectAtIndex:connectionIndex];
            [publicationDownloadResponses removeObjectAtIndex:connectionIndex];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == publicationsXmlConnection) {
        [publicationsXmlData setLength:0];
    } else {
        NSUInteger connectionIndex = [publicationDownloadConnections indexOfObjectIdenticalTo:connection];
        if (connectionIndex != NSNotFound) {
            NSMutableData *d = [publicationDownloadData objectAtIndex:connectionIndex];
            [d setLength:0];
            
            NSIndexPath *path = [publicationDownloadIndexPaths objectAtIndex:connectionIndex];
            DownloaderTableViewCell *cell = (DownloaderTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
            cell.downloadButton.hidden = YES;
            cell.progressView.progress = 0.0;
            cell.progressView.hidden = NO;
            
            NSNumber *expectedSize = [NSNumber numberWithFloat:(float)[response expectedContentLength]];
            [publicationDownloadResponses replaceObjectAtIndex:connectionIndex withObject:expectedSize];
        }
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
            
            float totalSize = [(NSNumber *)[publicationDownloadResponses objectAtIndex:connectionIndex] floatValue];
            float currentSize = (float)[d length];
            float progress = currentSize / totalSize;
            
            NSIndexPath *path = [publicationDownloadIndexPaths objectAtIndex:connectionIndex];
            DownloaderTableViewCell *cell = (DownloaderTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
            
            cell.progressView.progress = progress;
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == publicationsXmlConnection) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:publicationsXmlData];
        
        [publicationsXmlConnection release];
        [publicationsXmlData release];
        
        [self showStatusWithMessage:@"Список получен. Разбираю."];
        [parser setDelegate:self];
        [parser parse];
    } else {
        NSUInteger connectionIndex = [publicationDownloadConnections indexOfObjectIdenticalTo:connection];
        
        if (connectionIndex != NSNotFound) {
            NSMutableData *data = [publicationDownloadData objectAtIndex:connectionIndex];
            NSIndexPath *path = [publicationDownloadIndexPaths objectAtIndex:connectionIndex];
            NSDictionary *cellData = (NSDictionary *)[remotePublicationList objectAtIndex:[path row]];
            NSString *ID = (NSString *)[cellData valueForKey:@"id"];
            
            NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectoryPath = [directories objectAtIndex:0];
            NSString *zipDestination = [[documentDirectoryPath stringByAppendingPathComponent:ID] stringByAppendingString:@".zip"];
            
            [[NSFileManager defaultManager] createFileAtPath:zipDestination contents:data attributes:nil];
            
            NSString *folderDestination = [documentDirectoryPath stringByAppendingPathComponent:ID];
            [SSZipArchive unzipFileAtPath:zipDestination toDestination:folderDestination];
            
            [[NSFileManager defaultManager] removeItemAtPath:zipDestination error:nil];
            
            [publicationDownloadConnections removeObjectAtIndex:connectionIndex];
            [publicationDownloadData removeObjectAtIndex:connectionIndex];
            [publicationDownloadIndexPaths removeObjectAtIndex:connectionIndex];
            [publicationDownloadResponses removeObjectAtIndex:connectionIndex];
            
            [self showStatusWithMessage:@"Публикация скачена"];
            
            [self updateLocalPublications];
            
            // переход на свежескаченный журнал с главной страницы
            if (self.publicationToShow != nil) {
                // меняем кнопку на главной, т.к. журнальчик-то уже скачали
                [[(FSKN_2AppDelegate *)[[UIApplication sharedApplication] delegate] loadMagazineButton] setHidden:YES];
                [[(FSKN_2AppDelegate *)[[UIApplication sharedApplication] delegate] readMagazineButton] setHidden:NO];
                
                [self showPublicationWithID:self.publicationToShow];
                self.publicationToShow = nil;
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
    if (!remoteXMLLoading) {
        BOOL hasInternet = [self checkNetworkStatus];
        if (hasInternet) {
            BOOL downloading = [self publicationsAreDownloading];
            if (downloading) {
                _wantPublicationsButton.title = @"Дождитесь скачки всех публикаций";
                _wantPublicationsButton.enabled = NO;
                [self performSelector:@selector(restoreWantPublicationsButton) withObject:self afterDelay:3.0f];
            } else {
                _wantPublicationsButton.title = @"Получаю список публикаций";
                _wantPublicationsButton.enabled = NO;
                [self loadPublicationsXml];
                [self showStatusWithMessage:@"Есть подключение. Получаю список публикаций."];
            }
        } else {
            [self showStatusWithMessage:@"Доступ в интернет отсутствует."];
            _wantPublicationsButton.title = @"Отсутствует доступ в Интернет";
            _wantPublicationsButton.enabled = NO;
            [self performSelector:@selector(restoreWantPublicationsButton) withObject:self afterDelay:3.0f];
        }
    } else {
        _wantPublicationsButton.title = @"Список публикаций скачивается";
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



- (void)loadImageForCellAtIndex:(NSIndexPath *)indexPath withPath:(NSString *)path
{
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (publicationCoversCache == nil) {
            publicationCoversCache = [[NSMutableDictionary alloc] init];
        }
        [publicationCoversCache setObject:image forKey:indexPath];
        
        DownloaderTableViewCell *cell = (DownloaderTableViewCell *)[[self tableView] cellForRowAtIndexPath:indexPath];
        
        if (cell.coverView.image == nil) {
            cell.coverView.image = image;
            cell.coverView.hidden = NO;
        }
    }];
    [imageLoadOperationQueue addOperation:op];
}

- (void)loadButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    DownloaderTableViewCell *cell = (DownloaderTableViewCell *)[[button superview] superview];
    
    NSIndexPath *path = [[self tableView] indexPathForCell:cell];
    
    [self loadPublicationForCellAtPath:path];
}

- (void)loadPublicationForCellAtPath:(NSIndexPath *)path
{
    NSDictionary *cellData = (NSDictionary *)[remotePublicationList objectAtIndex:[path row]];
    NSURLRequest *r = [NSURLRequest requestWithURL:[NSURL URLWithString:[cellData valueForKey:@"path"]]];
    NSURLConnection *c = [NSURLConnection connectionWithRequest:r delegate:self];
    NSMutableData *data = [NSMutableData data];
    
    if (publicationDownloadConnections == nil) {
        publicationDownloadConnections = [[NSMutableArray alloc] init];
    }
    if (publicationDownloadData == nil) {
        publicationDownloadData = [[NSMutableArray alloc] init];
    }
    if (publicationDownloadIndexPaths == nil) {
        publicationDownloadIndexPaths = [[NSMutableArray alloc] init];
    }
    if (publicationDownloadResponses == nil) {
        publicationDownloadResponses = [[NSMutableArray alloc] init];
    }
    
    [publicationDownloadIndexPaths addObject:path];
    [publicationDownloadConnections addObject:c];
    [publicationDownloadData addObject:data];
    [publicationDownloadResponses addObject:[NSNumber numberWithFloat:0.0]];
}

- (void)loadPublicationWithID:(NSString *)ID
{
    int i = 0;
    BOOL found = NO;
    for (; i < [remotePublicationList count]; i++) {
        if ([[(NSDictionary *)[remotePublicationList objectAtIndex:i] valueForKey:@"id"] isEqualToString:ID]) {
            found = YES;
            break;
        }
    }
    
    if (found) {
        NSUInteger indexArr[] = { 0, i };
        NSIndexPath *path = [NSIndexPath indexPathWithIndexes:indexArr length:2];
        [self loadPublicationForCellAtPath:path];
    }
}



- (BOOL)publicationsAreDownloading
{
    BOOL downloading = NO;
    if ([publicationDownloadConnections count]) {
        downloading = YES;
    }
    
    return downloading;
}


@end
