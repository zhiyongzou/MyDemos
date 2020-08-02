//
//  HBNewsModel.h
//  HBullShares
//
//  Created by zzyong on 2020/8/1.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBNewsModel : NSObject

/// 新闻标题
@property (nonatomic, strong) NSString *title;
/// 新闻时间
@property (nonatomic, assign) NSTimeInterval timestamp;
/// 新闻图片
@property (nonatomic, strong) NSArray<NSString *> *thumbs;
/// 新闻来源s
@property (nonatomic, strong) NSString *author;
/// 新闻内容
@property (nonatomic, strong) NSString *url;

@end

NS_ASSUME_NONNULL_END
