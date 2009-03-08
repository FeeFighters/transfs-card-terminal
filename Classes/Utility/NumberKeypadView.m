//
//  NumberKeypadView.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 3/6/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "NumberKeypadView.h"


@implementation NumberKeypadView

@synthesize delegate;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
		[self setOpaque:false];
		//[self setUserInteractionEnabled:false];
        
		keypadButtons = [[NSMutableArray alloc] initWithCapacity:12];
		
		for (int i=0; i<12; i++) {
			UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
			
			CGRect btnFrame = CGRectMake(0, 0, 100, 80);
			CGSize btnNarrow = CGSizeMake((float)self.frame.size.width / 3.0, (float)self.frame.size.height / 4.0);
			CGSize btnWide = CGSizeMake(self.frame.size.width - 2*btnNarrow.width, self.frame.size.height - 3*btnNarrow.height);
			if (i==7 || i==4 || i==1 || i==10) {
				// Left
				btnFrame.size.width = btnNarrow.width;
			} else if (i==8 || i==5 || i==2 || i==0) {
				// Middle
				btnFrame.size.width = btnNarrow.width;
				btnFrame.origin.x = btnNarrow.width;				
			} else {
				// Right
				btnFrame.size.width = btnNarrow.width;
				btnFrame.origin.x = btnNarrow.width + btnWide.width;
			}
			if (i==7 || i==8 || i==9) {
				// Top
				btnFrame.size.height = btnNarrow.height;				
			} else if (i==4 || i==5 || i==6) {
				// Middle
				btnFrame.size.height = btnNarrow.height;				
				btnFrame.origin.y = btnNarrow.height;
			} else if (i==1 || i==2 || i==3) {
				// Bottom-numbers
				btnFrame.size.height = btnNarrow.height;
				btnFrame.origin.y = 2*btnNarrow.height;
			} else {
				// Bottom
				btnFrame.size.height = btnWide.height;
				btnFrame.origin.y = 3*btnNarrow.height;
			}			
			[newButton setFrame:btnFrame];
			
			[newButton setFont:[UIFont systemFontOfSize:28.0]];
			[newButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
			[newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[newButton setBackgroundImage:[UIImage imageNamed:@"keypad_button_normal.png"] forState:UIControlStateNormal];
			[newButton setBackgroundImage:[UIImage imageNamed:@"keypad_button_highlighted.png"] forState:UIControlStateHighlighted];			
			[newButton setUserInteractionEnabled:true];
			
			[newButton addTarget:self action:@selector(keypadButtonTouchUpInside:forEvent:) forControlEvents:UIControlEventTouchUpInside];

			[keypadButtons addObject:newButton];
			[self addSubview:newButton];
		}
		
		[[keypadButtons objectAtIndex:10] setTitle:@"." forState:UIControlStateNormal];
		[[keypadButtons objectAtIndex:11] setTitle:@"<-" forState:UIControlStateNormal];
		
    }
    return self;
}

- (void)keypadButtonTouchUpInside:(id)sender forEvent:(UIEvent *)event
{
	UIButton* button = (UIButton*)sender;
	
	if (delegate) {
		if (button == [keypadButtons objectAtIndex:11]) {
			if ([delegate respondsToSelector:@selector(keypadBackspacePressed:)])
				[delegate keypadBackspacePressed:button];
		}
		else if (button == [keypadButtons objectAtIndex:10]) {
			if ([delegate respondsToSelector:@selector(keypadPeriodPressed:)])
				[delegate keypadPeriodPressed:button];
		}
		else {
			if ([delegate respondsToSelector:@selector(keypadNumberPressed:button:)])			
				[delegate keypadNumberPressed:[keypadButtons indexOfObject:button] button:button];
		}
	}
}
			
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
	[keypadButtons release];
}


@end
