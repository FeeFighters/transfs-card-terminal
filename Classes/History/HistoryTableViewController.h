//
//  HistoryTableViewController.h
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 2/24/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryDetailViewController.h"

@interface HistoryTableViewController : UITableViewController {
	IBOutlet HistoryDetailViewController* detailViewController;
	IBOutlet UITableViewCell* tableCell;
	
	IBOutlet TransFS_Card_TerminalAppDelegate* delegate;
}

@end
