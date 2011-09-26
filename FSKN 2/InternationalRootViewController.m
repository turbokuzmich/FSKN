//
//  RootViewController.m
//  FSKN 2
//
//  Created by Дмитрий on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InternationalRootViewController.h"

#import "InternationalDetailViewController.h"

@implementation InternationalRootViewController

@synthesize detailViewController, list;

-(void)awakeFromNib
{
    NSArray *contents = [[NSArray alloc] initWithObjects:@"Дэвид Джонсон, Помощник Госсекретаря США. Брифинг по представлению Отчета Государственного Департамента США по международной антинаркотической стратегии 2010 г.", @"Выступление министра иностранных дел Российской Федерации Сергея Викторовича Лаврова на Международном форуме «Афганское наркопроизводство — вызов мировому сообществу»", @"Выступление Президента Российской Федерации Дмитрия Анатольевича Медведева на Международном форуме «Афганское наркопроизводство – вызов мировому сообществу»", @"Декларация десятого заседания Совета глав государств — членов Шанхайской организации сотрудничества", @"ЗАЯВЛЕНИЕ ОДКБ 21 февраля 2011 по афг наркотрафику", @"Итоговое заявление Международного форума «Афганское наркопроизводство – вызов мировому сообществу» (Москва, 9-10 июня 2010 года)", @"Совместное заявление президентов Российской Федерации и&nbsp;Соединённых Штатов Америки по&nbsp;Афганистану 24 июня 2010", @"Совместное заявление Российско-американско группы от 4 февраля 2010", @"Статья В.П. Иванова в газете «Известия» от 02.12.2010 г.", nil];
    self.list = contents;
    [contents release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Оглавление";
    self.view.backgroundColor = [UIColor colorWithRed:0.83 green:0.843 blue:0.87 alpha:1.0];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    detailViewController.detailItem = [[NSNumber alloc] initWithUnsignedInt:0];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = (NSString *)[self.list objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = (NSString *)[list objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:21.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height + 20.0f;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here -- for example, create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    detailViewController.detailItem = [[NSNumber alloc] initWithUnsignedInt:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [list release];
    [detailViewController release];
    [super dealloc];
}

@end
