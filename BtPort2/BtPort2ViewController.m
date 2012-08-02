//
//  BtPort2ViewController.m
//  BtPort2
//
//  Created by Michael Compas on 8/2/12.
//  Copyright (c) 2012 Concentric. All rights reserved.
//

#import "BtPort2ViewController.h"
#import "ResultsViewController.h"

@interface BtPort2ViewController ()

@end

@implementation BtPort2ViewController
{
	NSString *query;
	NSArray *term;
	int scope;
}
@synthesize search;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	
	self.navigationController.navigationBarHidden = YES;
	
	
	UISearchBar *s = self.search;
	s.showsScopeBar = NO;
	[s sizeToFit];
	
	term = [NSArray arrayWithObjects:@"artists", @"track", @"label", @"everything", nil];
}

- (void)viewDidUnload
{
	[self setSearch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// delegate actions for search bar
// ===============================================================

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	searchBar.showsScopeBar = YES;
	[searchBar sizeToFit];
	//NSLog(@"Editing: %@", searchBar.text);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	query = searchBar.text;
	scope = searchBar.selectedScopeButtonIndex;
	NSLog(@"Searching for: %@ in %@", query, [term objectAtIndex:scope]);
	//UIViewController *resultsView = [self.storyboard instantiateViewControllerWithIdentifier:@"resultsView"];
	//[self.navigationController pushViewController:resultsView animated:YES];
	[self performSegueWithIdentifier:@"toResults" sender:self];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	searchBar.text = nil;
	searchBar.showsScopeBar = NO;
	[searchBar sizeToFit];
}

//


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([[segue identifier] isEqualToString:@"toResults"])
	{
		ResultsViewController *rvc = (ResultsViewController *) [segue destinationViewController];
		rvc.query = query;
		rvc.delegate = self;
		rvc.scope = scope;
		
	}
}

//-(IBAction)showResults:(id)sender
//{
//	NSLog(@"show results...");
//	//[self performSegueWithIdentifier:@"homeToResults" sender:self];
//	UIViewController *rv = [self.storyboard instantiateViewControllerWithIdentifier:@"resultsView"];
//	[self.navigationController pushViewController:rv animated:YES];
//}


@end
