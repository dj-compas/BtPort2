//
//  ResultsViewController.m
//  BtPort2
//
//  Created by Michael Compas on 8/2/12.
//  Copyright (c) 2012 Concentric. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()
{
	NSData *data;
	NSDictionary *json;
	NSURL *url;
	NSMutableArray *resultsArray;
}

@end

@implementation ResultsViewController
@synthesize query;
@synthesize delegate;
@synthesize scope;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		
		//UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:nil action:nil];
		
		//[self.navigationController.navigationItem setBackBarButtonItem:backButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBarHidden = NO;
	self.navigationController.delegate = self;
	
	// modify search query based on scope
	
	resultsArray = [NSMutableArray array];
	
	url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://api.beatport.com/catalog/search?v=2.0&format=json&perPage=50&query=%@", [query stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
	data = [[NSData alloc] initWithContentsOfURL:url];
	json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
	
	switch (scope) {
		case 0:
			[self filterArtists];
			break;
		
		case 1:
			[self filterTracks];
			break;
		
		case 2:
			[self filterLabels];
			break;
		
		case 3:
			[self showAll];
			break;
			
		default:
			break;
	}
	
	
	NSLog(@"from Results view, query: %@", query);
	//NSLog(@"%@", [json objectForKey:@"results"]);
	
	
}

-(void)filterArtists
{
	int resultsCount = [[json objectForKey:@"results"] count];
	//NSLog(@"results count:%i", resultsCount);
	
	for (int i=0; i<resultsCount; ++i) {
		NSString *type = [[[json objectForKey:@"results"] objectAtIndex:i] valueForKey:@"type"];
		
		//NSLog(@"type: %@ / %@", type, [type isEqualToString:@"artist"] ? @"YES" : @"NO");
		//NSLog(@"type is type of: %@", [type isKindOfClass:[NSString class]] ? @"string" : @"unknown" );
		
		if ([type isEqualToString:@"artist"])
		{
			NSString *artist = [[[json objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"];
			[resultsArray addObject:artist];
			//NSLog(@"\t\t\tartist: %@", artist);
		}
	}
	
	NSLog(@"%@, count: %i", resultsArray, resultsArray.count);
}

-(void)filterTracks
{
	int resultsCount = [[json objectForKey:@"results"] count];
	
	for (int i=0; i<resultsCount; ++i) {
		NSString *type = [[[json objectForKey:@"results"] objectAtIndex:i] valueForKey:@"type"];
		
		if ([type isEqualToString:@"track"])
		{
			NSString *track = [[[json objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"];
			[resultsArray addObject:track];
		}
	}
	
	NSLog(@"%@, count: %i", resultsArray, resultsArray.count);
}

-(void)filterLabels
{
	int resultsCount = [[json objectForKey:@"results"] count];
	
	for (int i=0; i<resultsCount; ++i) {
		NSString *type = [[[json objectForKey:@"results"] objectAtIndex:i] valueForKey:@"type"];
		
		if ([type isEqualToString:@"label"])
		{
			NSString *label = [[[json objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"];
			[resultsArray addObject:label];
		}
	}
	
	NSLog(@"%@, count: %i", resultsArray, resultsArray.count);
}

-(void)showAll
{
	int resultsCount = [[json objectForKey:@"results"] count];
	
	for (int i=0; i<resultsCount; ++i) {
		//NSString *type = [[[json objectForKey:@"results"] objectAtIndex:i] valueForKey:@"type"];
		
		//if ([type isEqualToString:@"label"])
		//{
			NSString *result = [[[json objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"];
			[resultsArray addObject:result];
		//}
	}
	
	NSLog(@"%@, count: %i", resultsArray, resultsArray.count);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if(viewController == self.delegate)
	{
		NSLog(@"moving back to home screen");
		UIViewController *home = self.delegate;
		home.navigationController.navigationBarHidden = YES;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [resultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.textLabel.text = [resultsArray objectAtIndex:indexPath.row];
	
	
    return cell;
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
