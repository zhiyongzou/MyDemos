//
//  main.m
//  BlockDemo
//
//  Created by zzyong on 2020/6/7.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        static int num = 0;
        
        void (^myBlock)(void) = ^{
            NSLog(@"num: %d", num);
        };
        
        num = 1;
        
        myBlock();
    }
    return 0;
}
