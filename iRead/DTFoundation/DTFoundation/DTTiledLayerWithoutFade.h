//
//  DTTiledLayerWithoutFade.h
//  DTRichTextEditor
//
//  Created by Oliver Drobnik on 8/24/11.
//  Copyright 2011 Cocoanetics. All rights reserved.
//

#import <Availability.h>
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

/**
 Simple subclass of `CATiledLayer` that does not fade in drawn tiles.
 */

@interface DTTiledLayerWithoutFade : CATiledLayer

@end

#endif
