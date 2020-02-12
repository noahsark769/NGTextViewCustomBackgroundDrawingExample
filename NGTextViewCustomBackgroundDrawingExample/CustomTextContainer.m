//
//  CustomTextContainer.m
//  NGTextViewCustomBackgroundDrawingExample
//
//  Created by Noah Gilmore on 9/26/19.
//  Copyright © 2019 Noah Gilmore. All rights reserved.
//

#import "CustomTextContainer.h"
#import <AppKit/AppKit.h>

//final class CustomTextContainer: NSTextContainer {
//    override func lineFragmentRect(forProposedRect proposedRect: NSRect, sweepDirection: NSLineSweepDirection, movementDirection: NSLineMovementDirection, remaining remainingRect: NSRectPointer?) -> NSRect {
//        return super.lineFragmentRect(forProposedRect: proposedRect, sweepDirection: sweepDirection, movementDirection: movementDirection, remaining: remainingRect)
//    }
//}

@implementation CustomTextContainer

- (NSRect)lineFragmentRectForProposedRect:(NSRect)proposedRect atIndex:(NSUInteger)characterIndex writingDirection:(NSWritingDirection)baseWritingDirection remainingRect:(nullable NSRect *)remainingRect API_AVAILABLE(macos(10.11), ios(7.0), tvos(9.0)) {
    NSLog(@"Calling this dogshit! proposedRect: %@, characterIndex: %d", @(proposedRect), characterIndex);
    return [super lineFragmentRectForProposedRect:proposedRect atIndex:characterIndex writingDirection:baseWritingDirection remainingRect:remainingRect];
}

@end
