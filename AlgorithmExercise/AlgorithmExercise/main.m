//
//  main.m
//  AlgorithmExercise
//
//  Created by zzyong on 2020/5/13.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 选择排序
    时间复杂度：O(n^2)
    空间复杂度：O(1)

 算法步骤
    1. 首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置。
    2. 再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾。
    3. 重复第二步，直到所有元素均排序完毕。
 */
NSArray * selectSort(NSMutableArray * list)
{
    int minindex;
    id temp;
    for (int idx = 0; idx < list.count; idx++) {
        minindex = idx;
        for (int j = idx + 1; j < list.count; j++) {
            if ([list[minindex] integerValue] > [list[j] integerValue]) {
                minindex = j;
            }
        }
        
        if (minindex > idx) {
            temp = list[idx];
            list[idx] = list[minindex];
            list[minindex] = temp;
        }
    }
    
    return list;
}

int findDiffSquareElement(NSArray *list)
{
    if (list.count == 0) {
        return 0;;
    }
    
    int num = 0;
    int current = 0;
    BOOL hasContinue = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int idx = 0; idx < list.count; idx++) {
        NSNumber *element = list[idx];
        
        if (element.intValue < 0) {
            [dic setObject:@(0) forKey:@(-element.intValue)];
        }
        
        if (idx == 0) {
            current = element.intValue;
            continue;
        }
        
        if (element.intValue > 0 && [dic objectForKey:element]) {
            
            if ([[dic objectForKey:element] boolValue]) {
                num--;
            }
            current = element.intValue;
            [dic removeObjectForKey:element];
            continue;
        }
        
        if (current == element.intValue) {
            hasContinue = YES;
            continue;
        }
        
        current = element.intValue;
        
        if (hasContinue) {
            hasContinue = NO;
            continue;
        }
        
        num++;
        
        if (element.intValue < 0) {
            [dic setObject:@(1) forKey:@(-element.intValue)];
        }
    }
    
    return num;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        NSArray *sortList = @[@1, @2, @23, @3, @33, @222, @90, @9, @79, @8];
        NSLog(@"Select Sort: %@", selectSort([sortList mutableCopy]));
        
        NSArray *squareList = @[@-9, @-9, @0, @1, @1, @2, @3, @3, @5, @5, @9, @9, @11, @11, @11, @12];
        NSLog(@"findDiffSquareElement: %d", findDiffSquareElement(squareList));
    }
    return 0;
}
