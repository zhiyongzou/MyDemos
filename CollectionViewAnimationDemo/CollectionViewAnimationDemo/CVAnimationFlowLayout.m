//
//  CVAnimationFlowLayout.m
//  CollectionViewAnimationDemo
//
//  Created by zzyong on 2020/6/18.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "CVAnimationFlowLayout.h"

@interface CVAnimationFlowLayout ()

@property (nonatomic, strong) NSMutableSet *indexPathsToAnimate;

@end

@implementation CVAnimationFlowLayout

//- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
//{
//    NSLog(@"%@ prepare for updated", self);
//    [super prepareForCollectionViewUpdates:updateItems];
//    NSMutableSet *indexPaths = [NSMutableSet set];
//    for (UICollectionViewUpdateItem *updateItem in updateItems) {
//        switch (updateItem.updateAction) {
//            case UICollectionUpdateActionInsert:
//                [indexPaths addObject:updateItem.indexPathAfterUpdate];
//                break;
////            case UICollectionUpdateActionDelete:
////                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
////                break;
//            default:
//                NSLog(@"unhandled case: %@", updateItem);
//                break;
//        }
//    }
//    
//    self.indexPathsToAnimate = indexPaths;
//}
//
//- (void)finalizeCollectionViewUpdates
//{
//    NSLog(@"%@ finalize updates", self);
//    [super finalizeCollectionViewUpdates];
//    self.indexPathsToAnimate = nil;
//}
//
//- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    
//    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
//        attr.alpha = 0;
//        attr.frame = CGRectMake(0, -50, 0, 0);
//        [_indexPathsToAnimate removeObject:itemIndexPath];
//    }
//    
//    return attr;
//}
//
////- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
////{
////    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
////
////    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
////        attr.alpha = 1;
////        [_indexPathsToAnimate removeObject:itemIndexPath];
////    }
////
////    return attr;
////}
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    if (!CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size)) {
//        return YES;
//    }
//    return NO;
//}

@end
