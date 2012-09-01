//
//  PSMLiveChatTabStyle.m
//  --------------------
//
//  Created by Keith Blount on 30/04/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PSMLiveChatTabStyle.h"
#import "PSMTabBarCell.h"
#import "PSMTabBarControl.h"
#import "NSBezierPath_AMShading.h"

@interface PSMLiveChatTabStyle (Private)
- (void)drawInteriorWithTabCell:(PSMTabBarCell *)cell inView:(NSView*)controlView;
@end

@implementation PSMLiveChatTabStyle

@synthesize leftMarginForTabBarControl = _leftMargin;

- (NSString *)name {
	return @"LiveChat";
}

#pragma mark -
#pragma mark Creation/Destruction

- (id) init {
	if((self = [super init])) {
		liveChatCloseButton = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"AquaTabClose_Front"]];
		liveChatCloseButtonDown = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"AquaTabClose_Front_Pressed"]];
		liveChatCloseButtonOver = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"AquaTabClose_Front_Rollover"]];

		liveChatCloseDirtyButton = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"AquaTabCloseDirty_Front"]];
		liveChatCloseDirtyButtonDown = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Pressed"]];
		liveChatCloseDirtyButtonOver = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Rollover"]];

		_addTabButtonImage = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"AquaTabNew"]];
		_addTabButtonPressedImage = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"AquaTabNewPressed"]];
		_addTabButtonRolloverImage = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"AquaTabNewRollover"]];

		_objectCountStringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
										[[NSColor whiteColor] colorWithAlphaComponent:0.85], NSForegroundColorAttributeName,
										[[NSFontManager sharedFontManager] convertFont:[NSFont fontWithName:@"Lucida Grande" size:11.0] toHaveTrait:NSBoldFontMask], NSFontAttributeName,
										nil];
		_leftMargin = 5.0;
	}
	return self;
}

- (void)dealloc {
	[liveChatCloseButton release];
	[liveChatCloseButtonDown release];
	[liveChatCloseButtonOver release];
	[liveChatCloseDirtyButton release];
	[liveChatCloseDirtyButtonDown release];
	[liveChatCloseDirtyButtonOver release];
	[_addTabButtonImage release];
	[_addTabButtonPressedImage release];
	[_addTabButtonRolloverImage release];

	[_objectCountStringAttributes release];

	[super dealloc];
}

#pragma mark -
#pragma mark Control Specific

- (CGFloat)rightMarginForTabBarControl {
	return 24.0f;
}

- (CGFloat)topMarginForTabBarControl {
	return 10.0f;
}

- (void)setOrientation:(PSMTabBarOrientation)value {
}

#pragma mark -
#pragma mark Add Tab Button

- (NSImage *)addTabButtonImage {
	return _addTabButtonImage;
}

- (NSImage *)addTabButtonPressedImage {
	return _addTabButtonPressedImage;
}

- (NSImage *)addTabButtonRolloverImage {
	return _addTabButtonRolloverImage;
}

#pragma mark -
#pragma mark Drag Support

- (NSRect)dragRectForTabCell:(PSMTabBarCell *)cell orientation:(PSMTabBarOrientation)orientation {
	NSRect dragRect = [cell frame];
	dragRect.size.width++;
	return dragRect;
}

#pragma mark -
#pragma mark Providing Images

- (NSImage *)closeButtonImageOfType:(PSMCloseButtonImageType)type forTabCell:(PSMTabBarCell *)cell
{
    switch (type) {
        case PSMCloseButtonImageTypeStandard:
            return liveChatCloseButton;
        case PSMCloseButtonImageTypeRollover:
            return liveChatCloseButtonOver;
        case PSMCloseButtonImageTypePressed:
            return liveChatCloseButtonDown;
            
        case PSMCloseButtonImageTypeDirty:
            return liveChatCloseDirtyButton;
        case PSMCloseButtonImageTypeDirtyRollover:
            return liveChatCloseDirtyButtonOver;
        case PSMCloseButtonImageTypeDirtyPressed:
            return liveChatCloseDirtyButtonDown;
            
        default:
            break;
    }
    
}  // -closeButtonImageOfType:

#pragma mark -
#pragma mark Determining Cell Size

- (NSRect)iconRectForBounds:(NSRect)theRect ofTabCell:(PSMTabBarCell *)cell {
    
    if (![cell hasIcon])
        return NSZeroRect;

    NSImage *icon = [[(NSTabViewItem*)[cell representedObject] identifier] icon];
    if (!icon)
        return NSZeroRect;

    // calculate rect
    NSRect drawingRect = [cell drawingRectForBounds:theRect];
                
    NSSize iconSize = [icon size];
    
    NSSize scaledIconSize = [cell scaleImageWithSize:iconSize toFitInSize:NSMakeSize(iconSize.width, drawingRect.size.height) scalingType:NSImageScaleProportionallyDown];

    NSRect result = NSMakeRect(drawingRect.origin.x, drawingRect.origin.y, scaledIconSize.width, scaledIconSize.height);

    // center in available space (in case icon image is smaller than kPSMTabBarIconWidth)
    if(scaledIconSize.width < kPSMTabBarIconWidth) {
        result.origin.x += ceil((kPSMTabBarIconWidth - scaledIconSize.width) / 2.0);
    }

    if(scaledIconSize.height < kPSMTabBarIconWidth) {
        result.origin.y -= ceil((kPSMTabBarIconWidth - scaledIconSize.height) / 2.0 - 0.5);
    }

    return NSIntegralRect(result);
}

- (NSRect)titleRectForBounds:(NSRect)theRect ofTabCell:(PSMTabBarCell *)cell {
    
    NSRect drawingRect = [cell drawingRectForBounds:theRect];

    NSRect constrainedDrawingRect = drawingRect;
        
    NSRect iconRect = [cell iconRectForBounds:theRect];
    if (!NSEqualRects(iconRect, NSZeroRect))
        {
        constrainedDrawingRect.origin.x += NSWidth(iconRect)  + kPSMTabBarCellPadding;
        constrainedDrawingRect.size.width -= NSWidth(iconRect) + kPSMTabBarCellPadding;
        }
        
    NSRect indicatorRect = [cell indicatorRectForBounds:theRect];
    if (!NSEqualRects(indicatorRect, NSZeroRect))
        {
        constrainedDrawingRect.size.width -= NSWidth(indicatorRect) + kPSMTabBarCellPadding;
        }

    NSRect counterBadgeRect = [cell objectCounterRectForBounds:theRect];
    if (!NSEqualRects(counterBadgeRect, NSZeroRect))
        {
        constrainedDrawingRect.size.width -= NSWidth(counterBadgeRect) + kPSMTabBarCellPadding;
        }

    NSRect closeButtonRect = [cell closeButtonRectForBounds:theRect];
    if (!NSEqualRects(closeButtonRect, NSZeroRect))
        {
        constrainedDrawingRect.size.width -= NSWidth(closeButtonRect) + kPSMTabBarCellPadding;        
        }
                                    
    NSAttributedString *attrString = [cell attributedStringValue];
    if ([attrString length] == 0)
        return NSZeroRect;
        
    NSSize stringSize = [attrString size];
    
    NSRect result = NSMakeRect(constrainedDrawingRect.origin.x, drawingRect.origin.y+ceil((drawingRect.size.height-stringSize.height)/2), constrainedDrawingRect.size.width, stringSize.height);
                    
    return NSIntegralRect(result);
}

- (NSRect)objectCounterRectForBounds:(NSRect)theRect ofTabCell:(PSMTabBarCell *)cell {

    if([cell count] == 0) {
        return NSZeroRect;
    }

    NSRect drawingRect = [cell drawingRectForBounds:theRect];

    NSRect constrainedDrawingRect = drawingRect;

    NSRect indicatorRect = [cell indicatorRectForBounds:theRect];
    if (!NSEqualRects(indicatorRect, NSZeroRect))
        {
        constrainedDrawingRect.size.width -= NSWidth(indicatorRect) + kPSMTabBarCellPadding;
        }

    NSRect closeButtonRect = [cell closeButtonRectForBounds:theRect];
    if (!NSEqualRects(closeButtonRect, NSZeroRect))
        {
        constrainedDrawingRect.size.width -= NSWidth(closeButtonRect) + kPSMTabBarCellPadding;
        }
            
    NSSize counterBadgeSize = [cell objectCounterSize];
    
    // calculate rect
    NSRect result;
    result.size = counterBadgeSize; // temp
    result.origin.x = NSMaxX(constrainedDrawingRect)-counterBadgeSize.width;
    result.origin.y = ceil(constrainedDrawingRect.origin.y+(constrainedDrawingRect.size.height-result.size.height)/2);
                
    return NSIntegralRect(result);
}

- (NSRect)indicatorRectForBounds:(NSRect)theRect ofTabCell:(PSMTabBarCell *)cell {

    if([[cell indicator] isHidden]) {
        return NSZeroRect;
    }

    // calculate rect
    NSRect drawingRect = [cell drawingRectForBounds:theRect];

    NSRect constrainedDrawingRect = drawingRect;
    
    NSRect closeButtonRect = [cell closeButtonRectForBounds:theRect];
    if (!NSEqualRects(closeButtonRect, NSZeroRect))
        {
        constrainedDrawingRect.size.width -= NSWidth(closeButtonRect) + kPSMTabBarCellPadding;
        }
        
    NSSize indicatorSize = NSMakeSize(kPSMTabBarIndicatorWidth, kPSMTabBarIndicatorWidth);
    
    NSRect result = NSMakeRect(NSMaxX(constrainedDrawingRect)-indicatorSize.width,NSMidY(constrainedDrawingRect)-ceil(indicatorSize.height/2),indicatorSize.width,indicatorSize.height);
    
    return NSIntegralRect(result);
}

- (NSRect)closeButtonRectForBounds:(NSRect)theRect ofTabCell:(PSMTabBarCell *)cell {

    if ([cell shouldDrawCloseButton] == NO) {
        return NSZeroRect;
    }
    
    // ask style for image
    NSImage *image = [cell closeButtonImageOfType:PSMCloseButtonImageTypeStandard];
    if (!image)
        return NSZeroRect;
    
    // calculate rect
    NSRect drawingRect = [cell drawingRectForBounds:theRect];
        
    NSSize imageSize = [image size];
    
    NSSize scaledImageSize = [cell scaleImageWithSize:imageSize toFitInSize:NSMakeSize(imageSize.width, drawingRect.size.height) scalingType:NSImageScaleProportionallyDown];

    NSRect result = NSMakeRect(NSMaxX(drawingRect)-scaledImageSize.width, drawingRect.origin.y, scaledImageSize.width, scaledImageSize.height);

    if(scaledImageSize.height < drawingRect.size.height) {
        result.origin.y += ceil((drawingRect.size.height - scaledImageSize.height) / 2.0);
    }

    return NSIntegralRect(result);
}

- (CGFloat)tabCellHeight {
	return kPSMTabBarControlHeight;
}

#pragma mark -
#pragma mark Cell Values

- (NSAttributedString *)attributedObjectCountValueForTabCell:(PSMTabBarCell *)cell {
	NSString *contents = [NSString stringWithFormat:@"%lu", (unsigned long)[cell count]];
	return [[[NSMutableAttributedString alloc] initWithString:contents attributes:_objectCountStringAttributes] autorelease];
}

- (NSAttributedString *)attributedStringValueForTabCell:(PSMTabBarCell *)cell {
	NSMutableAttributedString *attrStr;
	NSString * contents = [cell stringValue];
	attrStr = [[[NSMutableAttributedString alloc] initWithString:contents] autorelease];
	NSRange range = NSMakeRange(0, [contents length]);

	[attrStr addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:11.0] range:range];

	// Paragraph Style for Truncating Long Text
	static NSMutableParagraphStyle *TruncatingTailParagraphStyle = nil;
	if(!TruncatingTailParagraphStyle) {
		TruncatingTailParagraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] retain];
		[TruncatingTailParagraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	}
	[attrStr addAttribute:NSParagraphStyleAttributeName value:TruncatingTailParagraphStyle range:range];

	return attrStr;
}

#pragma mark -
#pragma mark Drawing

- (void)drawBezelOfTabCell:(PSMTabBarCell *)cell withFrame:(NSRect)frame inView:(id)controlView {

NSRect cellFrame = [cell frame];

	NSToolbar *toolbar = [[[cell controlView] window] toolbar];
	BOOL showsBaselineSeparator = (toolbar && [toolbar respondsToSelector:@selector(showsBaselineSeparator)] && [toolbar showsBaselineSeparator]);
	if(!showsBaselineSeparator) {
		cellFrame.origin.y += 1.0;
		cellFrame.size.height -= 1.0;
	}

	NSColor * lineColor = nil;
	lineColor = [NSColor colorWithCalibratedWhite:0.576 alpha:1.0];

	BOOL selected = [cell state] == NSOnState;
	if(!showsBaselineSeparator || selected) {
		// selected tab
		NSRect aRect = NSMakeRect(cellFrame.origin.x + 0.5, cellFrame.origin.y - 0.5, cellFrame.size.width, cellFrame.size.height);
		if(selected) {
			aRect.origin.y -= 1.0;
			aRect.size.height += 1.0;
		}

		// frame
		CGFloat radius = MIN(6.0, 0.5f * MIN(NSWidth(aRect), NSHeight(aRect)));
		NSRect rect = NSInsetRect(aRect, radius, radius);

		NSPoint cornerPoint = NSMakePoint(NSMinX(aRect), NSMinY(aRect));
		NSBezierPath* bezier = [NSBezierPath bezierPath];
		[bezier appendBezierPathWithPoints:&cornerPoint count:1];

		[bezier appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect), NSMaxY(rect)) radius:radius startAngle:180.0 endAngle:90.0 clockwise:YES];

		[bezier appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) radius:radius startAngle:90.0 endAngle:360.0 clockwise:YES];

		cornerPoint = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
		[bezier appendBezierPathWithPoints:&cornerPoint count:1];

		if([[[tabBar tabView] window] isKeyWindow]) {
			if([cell state] == NSOnState) {
				[bezier linearGradientFillWithStartColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]
				 endColor:[NSColor colorWithCalibratedWhite:0.95 alpha:1.0]];
			} else if([cell isHighlighted]) {
				[bezier linearGradientFillWithStartColor:[NSColor colorWithCalibratedWhite:0.80 alpha:1.0]
				 endColor:[NSColor colorWithCalibratedWhite:0.80 alpha:1.0]];
			}
		} else if([cell state] == NSOnState) {
			[bezier linearGradientFillWithStartColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]
											endColor:[NSColor colorWithCalibratedWhite:0.95 alpha:1.0]];
		}

		[lineColor set];
		[bezier stroke];
	} else {
		// unselected tab
		NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
		aRect.origin.y += 0.5;
		aRect.origin.x += 1.5;
		aRect.size.width -= 1;

		aRect.origin.x -= 1;
		aRect.size.width += 1;

		// rollover
		if([cell isHighlighted]) {
			[[NSColor colorWithCalibratedWhite:0.0 alpha:0.1] set];
			NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);
		}

		// frame
		[lineColor set];
		if(!([cell tabState] & PSMTab_RightIsSelectedMask)) {
			[NSBezierPath strokeLineFromPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y + aRect.size.height - 0.5) toPoint:NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
		}
		// Create a thin lighter line next to the dividing line for a bezel effect
		if(!([cell tabState] & PSMTab_RightIsSelectedMask)) {
			[[[NSColor whiteColor] colorWithAlphaComponent:0.5] set];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(aRect) + 1.0, aRect.origin.y - 0.5)
			 toPoint:NSMakePoint(NSMaxX(aRect) + 1.0, NSMaxY(aRect) - 2.5)];
		}
	}
}

- (void)drawBackgroundInRect:(NSRect)rect {
	//Draw for our whole bounds; it'll be automatically clipped to fit the appropriate drawing area
	rect = [tabBar bounds];

	if([[[tabBar tabView] window] isKeyWindow]) {
		NSRect gradientRect = rect;
		gradientRect.origin.y += 1.0;
		NSBezierPath *path = [NSBezierPath bezierPathWithRect:gradientRect];
		[path linearGradientFillWithStartColor:[NSColor colorWithCalibratedWhite:0.75 alpha:1.0]
									  endColor:[NSColor colorWithCalibratedWhite:0.75 alpha:0.0]];
	}
	[[NSColor colorWithCalibratedWhite:0.576 alpha:1.0] set];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(rect.origin.x, NSMinY(rect) + 0.5)
							  toPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect) + 0.5)];
}

- (void)drawTabBar:(PSMTabBarControl *)bar inRect:(NSRect)rect {
	tabBar = bar;
	[self drawBackgroundInRect:rect];

	// no tab view == not connected
	if(![bar tabView]) {
		NSRect labelRect = rect;
		labelRect.size.height -= 4.0;
		labelRect.origin.y += 4.0;
		NSMutableAttributedString *attrStr;
		NSString *contents = @"PSMTabBarControl";
		attrStr = [[[NSMutableAttributedString alloc] initWithString:contents] autorelease];
		NSRange range = NSMakeRange(0, [contents length]);
		[attrStr addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:11.0] range:range];
		NSMutableParagraphStyle *centeredParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [centeredParagraphStyle setAlignment:NSCenterTextAlignment];
        
		[attrStr addAttribute:NSParagraphStyleAttributeName value:centeredParagraphStyle range:range];
		[attrStr drawInRect:labelRect];
        
        [centeredParagraphStyle release];
		return;
	}

	// draw cells
	NSEnumerator *e = [[bar cells] objectEnumerator];
	PSMTabBarCell *cell;
	while((cell = [e nextObject])) {
		if([bar isAnimating] || (![cell isInOverflowMenu] && NSIntersectsRect([cell frame], rect))) {
			[cell drawWithFrame:[cell frame] inView:bar];
		}
	}
}

#pragma mark -
#pragma mark Archiving

- (void)encodeWithCoder:(NSCoder *)aCoder {
	// ... do not encode anything
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	// ... do not read anything
	return [self init];
}

@end
