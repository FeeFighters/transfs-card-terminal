//
//  UICustomCellBackgroundView.h
//
//  Created by Mike Akers on 11/21/08.
//

#import <UIKit/UIKit.h>

typedef enum  {
	UICustomCellBackgroundViewPositionTop,
	UICustomCellBackgroundViewPositionMiddle,
	UICustomCellBackgroundViewPositionBottom,
	UICustomCellBackgroundViewPositionSingle
} UICustomCellBackgroundViewPosition;

@interface UICustomCellBackgroundView : UIView {
	UIColor *borderColor;
	UIColor *fillColor;
	UICustomCellBackgroundViewPosition position;
}

@property(nonatomic, retain) UIColor *borderColor, *fillColor;
@property(nonatomic) UICustomCellBackgroundViewPosition position;

@end