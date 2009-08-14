//
//  SettingsIndexViewController.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "SettingsIndexViewController.h"
#import "SettingsTableCell.h"
#import "NSStringAdditions.h"

@implementation SettingsIndexViewController

@synthesize aboutSettingsController, generalSettingsController, emailSettingsController;
@synthesize authNetSettingsController, paypalSettingsController, usaEpaySettingsController;
@synthesize selectedGatewayIndex;

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
	emailSettingsController = [[EmailSettingsViewController alloc] initWithNibName:@"EmailSettings" bundle:nil];
	generalSettingsController = [[GeneralSettingsViewController alloc] initWithNibName:@"GeneralSettings" bundle:nil];
	aboutSettingsController = [[AboutSettingsController alloc] initWithNibName:@"AboutSettings" bundle:nil];
	authNetSettingsController = [[AuthNetSettingsController alloc] initWithNibName:@"AuthNetSettings" bundle:nil];
	paypalSettingsController = [[PaypalSettingsController alloc] initWithNibName:@"PaypalSettings" bundle:nil];
	usaEpaySettingsController = [[UsaEpaySettingsController alloc] initWithNibName:@"UsaEpaySettings" bundle:nil];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	selectedGatewayIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"gatewayId"];
	self.navigationItem.title = @"About & Settings";
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSUserDefaults standardUserDefaults] setInteger:selectedGatewayIndex forKey:@"gatewayId"];
}


/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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

typedef enum sections {
	aboutSection = 0,
	generalSection,
	gatewaySection,
	emailSection,
	sectionCount
} tableSections;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionCount;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section==aboutSection)
		return 1;
	else if (section==gatewaySection)
		return gatewaysCount;
	else if (section==generalSection)
		return 1;
	else if (section==emailSection)
		return 1;
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section==aboutSection)
		return nil;
	else if (section==gatewaySection)
		return @"Processing Gateways:";
	else if (section==generalSection)
		return nil;
	else if (section==emailSection)
		return nil;
	return nil;
}

/*- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section==aboutSection) {
		return UITableViewCellAccessoryDetailDisclosureButton;
	}
	else if (indexPath.section==gatewaySection) {
		if (indexPath.row==selectedGatewayIndex)
			return UITableViewCellAccessoryCheckmark;
	}
	else if (indexPath.section==generalSection) {
		return UITableViewCellAccessoryDetailDisclosureButton;
	}
//	else if (indexPath.section==emailSection) {
//		return UITableViewCellAccessoryDetailDisclosureButton;
//	}

	return UITableViewCellAccessoryNone;
}
*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    SettingsTableCell* cell = (SettingsTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = (SettingsTableCell*)[[[NSBundle mainBundle] loadNibNamed:@"SettingsTableCells" owner:self options: nil] objectAtIndex:0];
    }

    if (indexPath.section==aboutSection)
	{
		cell.label.text = @"About TransFS Card Terminal";
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	else if (indexPath.section==gatewaySection)
	{
		if (indexPath.row==authNet) {
			cell.label.text = @"Authorize.Net";
		} else if (indexPath.row==paypal) {
			cell.label.text = @"Paypal Payments Pro";
		} else if (indexPath.row==usaEpay) {
				cell.label.text = @"USA ePay";
		}
		if (indexPath.row==selectedGatewayIndex)
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		else
			cell.accessoryType = UITableViewCellAccessoryNone;
	}
	else if (indexPath.section==generalSection)
	{
		cell.label.text = @"General Settings";
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	else if (indexPath.section==emailSection)
	{
		cell.label.text = @"Email Receipt Settings";
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];

	if (indexPath.section==gatewaySection) {
		selectedGatewayIndex = indexPath.row;
		[tableView reloadData];

		// Navigation logic may go here. Create and push another view controller.
		if (indexPath.row==authNet) {
			[self.navigationController pushViewController:authNetSettingsController animated:true];
		} else if (indexPath.row==paypal) {
			[self.navigationController pushViewController:paypalSettingsController animated:true];
		} else if (indexPath.row==usaEpay) {
			[self.navigationController pushViewController:usaEpaySettingsController animated:true];
		}
	}
	else if (indexPath.section==generalSection) {
		[self.navigationController pushViewController:generalSettingsController animated:true];
	}
	else if (indexPath.section==emailSection) {
		[self.navigationController pushViewController:emailSettingsController animated:true];
	}
	else if (indexPath.section==aboutSection) {
		[self.navigationController pushViewController:aboutSettingsController animated:true];
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
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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

