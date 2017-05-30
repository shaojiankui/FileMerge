//
//  FileDragView.h
//  FileMerge
//
//  Created by Jakey on 2017/5/30.
//  Copyright © 2017年 Jakey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void (^DidDragEnd)(NSArray *result);
@interface FileDragView : NSView<NSDraggingDestination>
{
    DidDragEnd _didDragEnd;
}
-(void)didDragEndBlock:(DidDragEnd)didDragEnd;
@end
