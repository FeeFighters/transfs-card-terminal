//
//  CustomCellBackgroundView.h
//
//  Created by Mike Akers on 11/21/08.
//

#import <UIKit/UIKit.h>

typedef enum  {
	CustomCellBackgroundViewPositionTop,
	CustomCellBackgroundViewPositionMiddle,
	CustomCellBackgroundViewPositionBottom,
	CustomCellBackgroundViewPositionSingle
} CustomCellBackgroundViewPosition;

@interface UICustomCellBackgroundView : UIView {
	UIColor *borderColor;
	UIColor *fillColor;
	CustomCellBackgroundViewPosition position;
}

@property(nonatomic, retain) UIColor *borderColor, *fillColor;
@property(nonatomic) CustomCellBackgroundViewPosition position;

@end