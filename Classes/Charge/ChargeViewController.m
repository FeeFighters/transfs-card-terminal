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
#import "UICustomCellBackgroundView.h"

@implementation ChargeViewController

@synthesize tableView, clearDataFlashView, processButton;
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

	if (![MFMailComposeViewController canSendMail]) {
		sendReceiptButton.hidden = YES;
	}

	tableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];

	self.navigationItem.title = @"Process Transaction";

	UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearData)];
	[self.navigationItem setRightBarButtonItem:clearButton animated:NO];
}

// Clear data for this form
- (void) clearData {
	[chargeAmountViewController clearData];
	[chargeCardNumberViewController clearData];
	[chargeCardNameViewController clearData];
	[chargeCardExpViewController clearData];
	[chargeCardCvvViewController clearData];
	[chargeAddressViewController clearData];
	[self.tableView reloadData];

	[[self.view superview] addSubview:clearDataFlashView];
	[UIView beginAnimations:@"clearDataFlash" context:nil];		//	Begin an animation block.
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[clearDataFlashView superview] cache:NO];
	[clearDataFlashView removeFromSuperview];
	[UIView commitAnimations];
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

	BillingGateway* gateway = [(TransFS_Card_TerminalAppDelegate*)[[UIApplication sharedApplication] delegate] setupGateway];
	recentSale = [Transaction transactionAndProcessWithGateway:gateway];

	if ([recentSale status]==TransactionSuccess)
	{
		[successViewImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"money_%d.png", (random() % 7)+1]]];
		[successViewLabel setText:[NSString stringWithFormat:@"Successfully Charged $%.2f to %@ %@'s Card", [recentSale.moneyAmount dollars], [recentSale firstName], [recentSale lastName]]];

		savedSubviewforSuccess = [[self tabBarController] view];
		UIView* curView = [savedSubviewforSuccess superview];
		[curView setBackgroundColor:[UIColor blackColor]];
		[UIView beginAnimations:@"successView" context:nil];		//	Begin an animation block.
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:curView cache:true];	//	Set the transition on the container view.
		//[savedSubviewforSuccess removeFromSuperview];	//	Remove the subview from the container view.
		[curView addSubview:successView];		//	Add the new subview to the container view.
		[UIView commitAnimations];
	}
	else
	{
		[responseLabel setText:[NSString stringWithString:[recentSale errorMessages]]];

		savedSubviewforSuccess = [[self tabBarController] view];
		UIView* curView = [savedSubviewforSuccess superview];
		[curView setBackgroundColor:[UIColor blackColor]];
		[UIView beginAnimations:@"failureView" context:nil];		//	Begin an animation block.
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:curView cache:true];	//	Set the transition on the container view.
		//[savedSubviewforSuccess removeFromSuperview];	//	Remove the subview from the container view.
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
	//[curView addSubview:savedSubviewforSuccess];		//	Add the new subview to the container view.
	[UIView commitAnimations];
}

- (IBAction) startOverButtonClick:(id)sender
{
	[chargeAmountViewController clearData];  // Reset amount field
	[self.tableView reloadData];

	UIView* curView = [successView superview];
	[UIView beginAnimations:@"startOver" context:nil];		//	Begin an animation block.
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:curView cache:true];	//	Set the transition on the container view.
	[successView removeFromSuperview];	//	Remove the subview from the container view.
	//[curView addSubview:savedSubviewforSuccess];		//	Add the new subview to the container view.
	[UIView commitAnimations];
}

- (IBAction) sendReceiptButtonClick:(id)sender
{
	MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];

	NSString* name = [[NSUserDefaults standardUserDefaults] stringForKey:@"emailReceiptName"];
	NSString* address = [[NSUserDefaults standardUserDefaults] stringForKey:@"emailReceiptAddress"];
	NSString* copy = [[NSUserDefaults standardUserDefaults] stringForKey:@"emailReceiptCopy"];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];

	[mailController setSubject:[NSString stringWithFormat:@"%@ - Credit Card Receipt",name]];
	NSArray* messageLines = [NSArray arrayWithObjects:
		copy,
		@"",
		[NSString stringWithFormat:@"%@ charged $%.2f to your card on %@:", name, [recentSale.moneyAmount dollars], [dateFormatter stringFromDate:recentSale.date]],
		@"",
		[NSString stringWithFormat:@"%@ %@", recentSale.firstName, recentSale.lastName],
		[NSString stringWithFormat:@"%@", recentSale.sanitizedCardNumber],
		@"",
		@"Merchant Contact Information:",
		name,
		address,
			nil];

	[mailController setMessageBody:[messageLines componentsJoinedByString:@"\n"] isHTML:NO];
	[mailController setCcRecipients:[NSArray arrayWithObjects:address,nil]];
	mailController.mailComposeDelegate = self;

	[[successView superview] sendSubviewToBack:successView];

	[self.navigationController presentModalViewController:mailController animated:YES];
	[mailController release];
}

// Mail Composer Delegate Callback
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[[successView superview] bringSubviewToFront:successView];
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
	UICustomCellBackgroundViewPosition position = UICustomCellBackgroundViewPositionMiddle;

	if (indexPath.row == 0) {
		cell = (ChargeTableAmountCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ChargeTableAmountCell"];
		if (cell == nil) {
			cell = (ChargeTableAmountCell*)[[[NSBundle mainBundle] loadNibNamed:@"ChargeTableCells" owner:self.tableView options: nil] objectAtIndex:0];
		}
		if ([NSString isBlank:chargeAmountViewController.number]) {
			((ChargeTableAmountCell*)cell).amount.text = @"$ 0.00";
		}
		else {
			((ChargeTableAmountCell*)cell).amount.text = [NSString stringWithFormat:@"$ %@", chargeAmountViewController.number];
		}
		position = UICustomCellBackgroundViewPositionTop;
	}
	else if (indexPath.row == 1) {
		cell = (ChargeTableCardNameCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ChargeTableCardNameCell"];
		if (cell == nil) {
			cell = (ChargeTableCardNameCell*)[[[NSBundle mainBundle] loadNibNamed:@"ChargeTableCells" owner:self.tableView options: nil] objectAtIndex:1];
		}
		if ([NSString isBlank:chargeCardNameViewController.firstName.text] || [NSString isBlank:chargeCardNameViewController.lastName.text]) {
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

		if ([NSString isBlank:chargeCardNumberViewController.number]) {
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

		if ([NSString isBlank:chargeCardCvvViewController.number]) {
			((ChargeTableCardExpCvvCell*)cell).cvv.hidden = true;
			((ChargeTableCardExpCvvCell*)cell).cvvDisabledLabel.hidden = false;
		}
		else {
			((ChargeTableCardExpCvvCell*)cell).cvv.hidden = false;
			((ChargeTableCardExpCvvCell*)cell).cvvDisabledLabel.hidden = true;
			((ChargeTableCardExpCvvCell*)cell).cvv.text = chargeCardCvvViewController.number;
		}

		if (![[NSUserDefaults standardUserDefaults] boolForKey:@"avsEnabled"])
			position = UICustomCellBackgroundViewPositionBottom;
	}
	else if (indexPath.row == 4) {
		cell = (ChargeTableAddressCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ChargeTableAddressCell"];
		if (cell == nil) {
			cell = (ChargeTableAddressCell*)[[[NSBundle mainBundle] loadNibNamed:@"ChargeTableCells" owner:self.tableView options: nil] objectAtIndex:4];
		}

		if ([NSString isBlank:chargeAddressViewController.zipcode.text]) {
			((ChargeTableAddressCell*)cell).address.hidden = true;
			((ChargeTableAddressCell*)cell).city.hidden = true;
			((ChargeTableAddressCell*)cell).zip.hidden = true;
			((ChargeTableAddressCell*)cell).disabledLabel.hidden = false;
		}
		else {
			((ChargeTableAddressCell*)cell).address.hidden = [NSString isBlank:chargeAddressViewController.address.text];
			((ChargeTableAddressCell*)cell).city.hidden = [NSString isBlank:chargeAddressViewController.city.text];
			((ChargeTableAddressCell*)cell).zip.hidden = [NSString isBlank:chargeAddressViewController.zipcode.text];
			((ChargeTableAddressCell*)cell).disabledLabel.hidden = true;
			((ChargeTableAddressCell*)cell).address.text = chargeAddressViewController.address.text;
			((ChargeTableAddressCell*)cell).city.text = chargeAddressViewController.city.text;
			((ChargeTableAddressCell*)cell).zip.text = chargeAddressViewController.zipcode.text;
		}
		position = UICustomCellBackgroundViewPositionBottom;
	}

	UICustomCellBackgroundView* customBg = [[UICustomCellBackgroundView alloc] initWithFrame:cell.backgroundView.frame];
	customBg.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
	customBg.fillColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	customBg.position = position;
	[cell.backgroundView release];
	cell.backgroundView = customBg;
	[cell.backgroundView setNeedsDisplay];

	return cell;
}


- (void)tableView:(UITableView *)_tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:_tableView didSelectRowAtIndexPath:indexPath];
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
