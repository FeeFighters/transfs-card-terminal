//
//  ChargeViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "ChargeViewController.h"
#import "ChargeTableAmountCell.h"
#import "ChargeTableCardNameCell.h"
#import "ChargeTableCardNumberCell.h"
#import "ChargeTableCardExpCvvCell.h"
#import "ChargeTableAddressCell.h"
#import "CreditCard.h"
#import "CreditCardMethods.h"
#import "Transaction.h"

@implementation ChargeViewController

@synthesize tableView;
@synthesize chargeAmountViewController, chargeCardNameViewController, chargeCardNumberViewController;
@synthesize chargeCardExpViewController, chargeCardCvvViewController, chargeAddressViewController;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
 
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	chargeAmountViewController = [[ChargeAmountViewController alloc] initWithNibName:@"ChargeAmountView" bundle:nil];
	chargeCardNumberViewController = [[ChargeCardNumberViewController alloc] initWithNibName:@"ChargeCardNumberView" bundle:nil];
	chargeCardNameViewController = [[ChargeCardNameViewController alloc] initWithNibName:@"ChargeCardNameView" bundle:nil];
	chargeCardExpViewController = [[ChargeCardExpViewController alloc] initWithNibName:@"ChargeCardExpView" bundle:nil];
	chargeCardCvvViewController = [[ChargeCardCvvViewController alloc] initWithNibName:@"ChargeCardCvvView" bundle:nil];
	chargeAddressViewController = [[ChargeAddressViewController alloc] initWithNibName:@"ChargeAddressView" bundle:nil];
	
	tableView.backgroundColor = self.view.backgroundColor;
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
	
//	self.navigationItem.prompt = @"TransFS.com Card Terminal";
	self.navigationItem.title = @"Process Transaction";	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) processButtonClick:(id)sender
{
	UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Process Transaction?" 
													   delegate:self 
											  cancelButtonTitle:nil 
										 destructiveButtonTitle:@"Cancel"
											  otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Proceed!"];
	
	[alert showInView:self.tabBarController.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==0) //Cancel
	{
		[processButton setEnabled:true];
		[processButton setHidden:false];
		[spinner stopAnimating];
		[spinner setHidden:true];
		[responseLabel setText:@"Transaction Cancelled."];
	}
	else if (buttonIndex==1)
	{
		[processButton setEnabled:false];
		[processButton setHidden:true];		
		[spinner startAnimating];
		[spinner setHidden:false];
		[responseLabel setText:@""];
		[NSThread detachNewThreadSelector:@selector(processTransactionThread) toTarget:self withObject:nil];
	}
}

- (void) processTransactionThread
{
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	
	[NSThread sleepForTimeInterval:0.5];
	
	Transaction* sale = [Transaction initAndProcessFromCurrentState];
	if ([sale status]==TransactionSuccess)
	{
		[successViewImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"money_%d.png", (random() % 7)+1]]];
		[successViewLabel setText:[NSString stringWithFormat:@"Successfully Charged $%.2f to %@ %@'s Card", [sale dollarAmount], [sale firstName], [sale lastName]]];
		
		savedSubviewforSuccess = [[self tabBarController] view];
		UIView* curView = [savedSubviewforSuccess superview];
		[curView setBackgroundColor:[UIColor blackColor]];
		[UIView beginAnimations:@"successView" context:nil];		//	Begin an animation block.
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:curView cache:true];	//	Set the transition on the container view.
		[savedSubviewforSuccess removeFromSuperview];	//	Remove the subview from the container view.
		[curView addSubview:successView];		//	Add the new subview to the container view.
		[UIView commitAnimations];
	}
	else
	{
		[responseLabel setText:[NSString stringWithString:[sale errorMessages]]];
		
		savedSubviewforSuccess = [[self tabBarController] view];
		UIView* curView = [savedSubviewforSuccess superview];
		[curView setBackgroundColor:[UIColor blackColor]];
		[UIView beginAnimations:@"failureView" context:nil];		//	Begin an animation block.
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:curView cache:true];	//	Set the transition on the container view.
		[savedSubviewforSuccess removeFromSuperview];	//	Remove the subview from the container view.
		[curView addSubview:failureView];		//	Add the new subview to the container view.
		[UIView commitAnimations];
	}
	
	[autoreleasepool release];
	
	[spinner stopAnimating];
	[processButton setEnabled:true];
	[processButton setHidden:false];
	[NSThread exit];
}

- (IBAction) goBackButtonClick:(id)sender
{
	[chargeAmountViewController.number setString:@""];  // Reset amount field

	UIView* curView = [failureView superview];
	[UIView beginAnimations:@"startOver" context:nil];		//	Begin an animation block.
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:curView cache:true];	//	Set the transition on the container view.
	[failureView removeFromSuperview];	//	Remove the subview from the container view.
	[curView addSubview:savedSubviewforSuccess];		//	Add the new subview to the container view.
	[UIView commitAnimations];
}

- (IBAction) startOverButtonClick:(id)sender
{
	[chargeAmountViewController.number setString:@""];  // Reset amount field

	UIView* curView = [successView superview];
	[UIView beginAnimations:@"startOver" context:nil];		//	Begin an animation block.
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:curView cache:true];	//	Set the transition on the container view.
	[successView removeFromSuperview];	//	Remove the subview from the container view.
	[curView addSubview:savedSubviewforSuccess];		//	Add the new subview to the container view.
	[UIView commitAnimations];

}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Set address visible based on preference setting
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"avsEnabled"])
		return 5;
    
	return 4;
}


// The accessory type is the image displayed on the far right of each table cell. In order for the delegate method
// tableView:accessoryButtonClickedForRowWithIndexPath: to be called, you must return the "Detail Disclosure Button" type.
/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 4)
		return 60.0;		
	
	return 45.0;	
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell* cell = nil;
	
	if (indexPath.row == 0) {
		cell = (ChargeTableAmountCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ChargeTableAmountCell"];
		if (cell == nil) {
			cell = (ChargeTableAmountCell*)[[[NSBundle mainBundle] loadNibNamed:@"ChargeTableCells" owner:self.tableView options: nil] objectAtIndex:0];
		}
		if ([NSString is_blank:chargeAmountViewController.number]) {
			((ChargeTableAmountCell*)cell).amount.text = @"$ 0.00";
		}
		else {	
			((ChargeTableAmountCell*)cell).amount.text = [NSString stringWithFormat:@"$ %@", chargeAmountViewController.number];
		}
	}
	else if (indexPath.row == 1) {
		cell = (ChargeTableCardNameCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ChargeTableCardNameCell"];
		if (cell == nil) {
			cell = (ChargeTableCardNameCell*)[[[NSBundle mainBundle] loadNibNamed:@"ChargeTableCells" owner:self.tableView options: nil] objectAtIndex:1];
		}
		if ([NSString is_blank:chargeCardNameViewController.firstName.text] || [NSString is_blank:chargeCardNameViewController.lastName.text]) {
			((ChargeTableCardNameCell*)cell).name.hidden = true;
			((ChargeTableCardNameCell*)cell).disabledLabel.hidden = false;
		}
		else {	
			((ChargeTableCardNameCell*)cell).name.hidden = false;
			((ChargeTableCardNameCell*)cell).disabledLabel.hidden = true;
			((ChargeTableCardNameCell*)cell).name.text = [NSString stringWithFormat:@"%@ %@", chargeCardNameViewController.firstName.text, chargeCardNameViewController.lastName.text];			
		}			
	}
	else if (indexPath.row == 2) {
		cell = (ChargeTableCardNumberCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ChargeTableCardNumberCell"];
		if (cell == nil) {
			cell = (ChargeTableCardNumberCell*)[[[NSBundle mainBundle] loadNibNamed:@"ChargeTableCells" owner:self.tableView options: nil] objectAtIndex:2];
		}
		
		if ([NSString is_blank:chargeCardNumberViewController.number]) {
			((ChargeTableCardNumberCell*)cell).number.hidden = true;
			((ChargeTableCardNumberCell*)cell).disabledLabel.hidden = false;
		}
		else {	
			((ChargeTableCardNumberCell*)cell).number.hidden = false;
			((ChargeTableCardNumberCell*)cell).disabledLabel.hidden = true;
			((ChargeTableCardNumberCell*)cell).number.text = [BillingCreditCard number:chargeCardNumberViewController.number withSeperator:@" "];
		}
		
		NSString *type = [BillingCreditCard getTypeWithPartialNumber:chargeCardNumberViewController.number];
		NSArray *validImages = [NSArray arrayWithObjects:@"visa", @"master", @"discover", @"american_express", nil];
		if ([validImages containsObject:type]) {
			NSString *filename = [NSString stringWithFormat:@"%@.png", type];
			UIImage *image = [UIImage imageNamed:filename];
			[((ChargeTableCardNumberCell*)cell).cardImage setImage:image];
		}
		else {
			UIImage *image = [UIImage imageNamed:@"unknown.png"];
			[((ChargeTableCardNumberCell*)cell).cardImage setImage:image];
		}
		
	}
	else if (indexPath.row == 3) {
		cell = (ChargeTableCardExpCvvCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ChargeTableCardExpCvvCell"];
		if (cell == nil) {
			cell = (ChargeTableCardExpCvvCell*)[[[NSBundle mainBundle] loadNibNamed:@"ChargeTableCells" owner:self.tableView options: nil] objectAtIndex:3];
			[(ChargeTableCardExpCvvCell*)cell setChargeView:self];
		}
		
		NSString* exp = [NSString stringWithFormat:@"%02d/%04d", 
						[chargeCardExpViewController.monthPicker selectedRowInComponent:0]+1, 
						[chargeCardExpViewController.yearPicker selectedRowInComponent:0]+[CardExpirationPickerDelegate currentYear]];
		((ChargeTableCardExpCvvCell*)cell).expDate.text = exp;

		if ([NSString is_blank:chargeCardCvvViewController.number]) {
			((ChargeTableCardExpCvvCell*)cell).cvv.hidden = true;
			((ChargeTableCardExpCvvCell*)cell).cvvDisabledLabel.hidden = false;
		}
		else {	
			((ChargeTableCardExpCvvCell*)cell).cvv.hidden = false;
			((ChargeTableCardExpCvvCell*)cell).cvvDisabledLabel.hidden = true;
			((ChargeTableCardExpCvvCell*)cell).cvv.text = chargeCardCvvViewController.number;
		}
	}
	else if (indexPath.row == 4) {
		cell = (ChargeTableAddressCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ChargeTableAddressCell"];
		if (cell == nil) {
			cell = (ChargeTableAddressCell*)[[[NSBundle mainBundle] loadNibNamed:@"ChargeTableCells" owner:self.tableView options: nil] objectAtIndex:4];
		}
		
		if ([NSString is_blank:chargeAddressViewController.zipcode.text]) {
			((ChargeTableAddressCell*)cell).address.hidden = true;
			((ChargeTableAddressCell*)cell).city.hidden = true;
			((ChargeTableAddressCell*)cell).zip.hidden = true;			
			((ChargeTableAddressCell*)cell).disabledLabel.hidden = false;
		}
		else {
			((ChargeTableAddressCell*)cell).address.hidden = [NSString is_blank:chargeAddressViewController.address.text];
			((ChargeTableAddressCell*)cell).city.hidden = [NSString is_blank:chargeAddressViewController.city.text];
			((ChargeTableAddressCell*)cell).zip.hidden = [NSString is_blank:chargeAddressViewController.zipcode.text];
			((ChargeTableAddressCell*)cell).disabledLabel.hidden = true;
			((ChargeTableAddressCell*)cell).address.text = chargeAddressViewController.address.text;
			((ChargeTableAddressCell*)cell).city.text = chargeAddressViewController.city.text;
			((ChargeTableAddressCell*)cell).zip.text = chargeAddressViewController.zipcode.text;
		}
		
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.row == 0) {
		[self.navigationController pushViewController:chargeAmountViewController animated:true];
	}
	else if (indexPath.row == 1) {
		[self.navigationController pushViewController:chargeCardNameViewController animated:true];
	}
	else if (indexPath.row == 2) {
		[self.navigationController pushViewController:chargeCardNumberViewController animated:true];
	}
	else if (indexPath.row == 3) {
	}
	else if (indexPath.row == 4) {
		[self.navigationController pushViewController:chargeAddressViewController animated:true];
	}	

	[self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

/*
- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
}
*/

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
