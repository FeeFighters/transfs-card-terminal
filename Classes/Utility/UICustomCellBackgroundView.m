//
//  UICustomCellBackgroundView.m
//
//  Created by Mike Akers on 11/21/08.
//

#import "UICustomCellBackgroundView.h"

#define ROUND_SIZE 10
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight);

@implementation UICustomCellBackgroundView
@synthesize borderColor, fillColor, position;

- (BOOL) isOpaque {
	return NO;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(c, [fillColor CGColor]);
	CGContextSetStrokeColorWithColor(c, [borderColor CGColor]);
	CGContextSetLineWidth(c, 1);
 	CGContextSetShouldAntialias(c, YES);

	if (position == UICustomCellBackgroundViewPositionTop) {
		CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
		CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
		minx = minx + 0.5f;
		miny = miny + 0.5f;

		maxx = maxx - 0.5f;
		maxy = maxy ;

		CGContextMoveToPoint(c, minx, maxy);
		CGContextAddArcToPoint(c, minx, miny, midx, miny, ROUND_SIZE);
		CGContextAddArcToPoint(c, maxx, miny, maxx, maxy, ROUND_SIZE);
		CGContextAddLineToPoint(c, maxx, maxy);

		// Close the path
		CGContextClosePath(c);
		// Fill & stroke the path
		CGContextDrawPath(c, kCGPathFillStroke);
		return;
	}
	else if (position == UICustomCellBackgroundViewPositionBottom) {
		CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
		CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
		minx = minx + 0.5f;
		miny = miny;

		maxx = maxx - 0.5f;
		maxy = maxy - 1.5f;

		CGContextMoveToPoint(c, minx, miny);
		CGContextAddArcToPoint(c, minx, maxy, midx, maxy, ROUND_SIZE);
		CGContextAddArcToPoint(c, maxx, maxy, maxx, miny, ROUND_SIZE);
		CGContextAddLineToPoint(c, maxx, miny);

		// Fill & stroke the path
		CGContextDrawPath(c, kCGPathFillStroke);
		return;
	}
	else if (position == UICustomCellBackgroundViewPositionMiddle) {
		CGFloat minx = CGRectGetMinX(rect) , maxx = CGRectGetMaxX(rect) ;
		CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
		minx = minx + 0.5f;
		miny = miny ;

		maxx = maxx - 0.5f;
		maxy = maxy ;

		CGContextMoveToPoint(c, minx, miny);
		CGContextAddLineToPoint(c, maxx, miny);
		CGContextAddLineToPoint(c, maxx, maxy);
		CGContextAddLineToPoint(c, minx, maxy);

		CGContextClosePath(c);
		// Fill & stroke the path
		CGContextDrawPath(c, kCGPathFill);

		CGContextMoveToPoint(c, minx, miny);
		CGContextAddLineToPoint(c, minx, maxy);
		CGContextAddLineToPoint(c, maxx, maxy);
		CGContextAddLineToPoint(c, maxx, miny);

		CGContextDrawPath(c, kCGPathStroke);
		return;
	}
	else if (position == UICustomCellBackgroundViewPositionSingle)
	{
		CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
		CGFloat miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
		minx = minx + 0.5f;
		miny = miny + 0.5f;

		maxx = maxx - 0.5f;
		maxy = maxy - 0.5f;

		CGContextMoveToPoint(c, minx, midy);
		CGContextAddArcToPoint(c, minx, miny, midx, miny, ROUND_SIZE);
		CGContextAddArcToPoint(c, maxx, miny, maxx, midy, ROUND_SIZE);
		CGContextAddArcToPoint(c, maxx, maxy, midx, maxy, ROUND_SIZE);
		CGContextAddArcToPoint(c, minx, maxy, minx, midy, ROUND_SIZE);

		// Close the path
		CGContextClosePath(c);
		// Fill & stroke the path
		CGContextDrawPath(c, kCGPathFillStroke);
		return;
	}

}

- (void)dealloc {
	[borderColor release];
	[fillColor release];
	[super dealloc];
}

@end

