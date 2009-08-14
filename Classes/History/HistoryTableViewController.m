//
//  HistoryTableViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/24/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "TransactionTableViewCell.h"

@implementation HistoryTableViewController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

	detailViewController = [[HistoryDetailViewController alloc] initWithNibName:@"HistoryDetailView" bundle:nil];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];

	//self.navigationItem.prompt = @"TransFS.com Card Terminal";
	self.navigationItem.title = @"Transaction History";
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

// Invoked when the user touches Edit.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Updates the appearance of the Edit|Done button as necessary.
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return delegate.transactionHistory.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionTableViewCell* cell = (TransactionTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"TransactionCell"];
    if (cell == nil) {
		cell = (TransactionTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"TransactionTableViewCell" owner:self options: nil] objectAtIndex:0];
	}

    // Retrieve the Transaction object matching the row from the application delegate's array.
    Transaction *transaction = (Transaction *)[delegate.transactionHistory objectAtIndex:indexPath.row];

    // Set up the cell...
	if (transaction.status == TransactionVoided) {
		[cell.amount setFont:[UIFont italicSystemFontOfSize:17]];
		[cell.amount setTextColor:[UIColor redColor]];
		[cell.name setFont:[UIFont italicSystemFontOfSize:17]];
		[cell.name setTextColor:[UIColor redColor]];
		[cell.date setFont:[UIFont italicSystemFontOfSize:17]];
		[cell.date setTextColor:[UIColor redColor]];
	} else {
		[cell.amount setFont:[UIFont systemFontOfSize:17]];
		[cell.amount setTextColor:[UIColor blackColor]];
		[cell.name setFont:[UIFont systemFontOfSize:17]];
		[cell.name setTextColor:[UIColor blackColor]];
		[cell.date setFont:[UIFont systemFontOfSize:17]];
		[cell.date setTextColor:[UIColor blackColor]];
	}
	[cell.name setText:[NSString stringWithFormat:@"%@ %@", transaction.firstName, transaction.lastName]];
	[cell.amount setText:[NSString stringWithFormat:@"%.2f", [transaction.moneyAmount dollars]]];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[cell.date setText:[dateFormatter stringFromDate:transaction.date]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Inspect the transaction (method defined above).
    Transaction *transaction = (Transaction *)[delegate.transactionHistory objectAtIndex:indexPath.row];
    // Retrieve the other attributes of the transaction from the database (if needed).
    [transaction hydrate];
    // Set the detail controller's inspected item to the currently-selected transaction.
    detailViewController.transaction = transaction;

	// Navigation logic may go here. Create and push another view controller.
	[self.navigationController pushViewController:detailViewController animated:true];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
									forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Find the book at the deleted row, and remove from application delegate's array.
		Transaction *transaction = (Transaction *)[delegate.transactionHistory objectAtIndex:indexPath.row];
        [delegate removeTransaction:transaction];
        // Animate the deletion from the table.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							  withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

