//
//  main.m
//  unzip
//
//  Created by zzyong on 2020/2/10.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        ZipArchive *zip = [[ZipArchive alloc] init];
        BOOL success =  [zip UnzipOpenFile:@"/Users/user/Downloads/luck.zip"];
        if (!success) {
            NSLog(@"unzip failed");
        }
    }
    return 0;
}
