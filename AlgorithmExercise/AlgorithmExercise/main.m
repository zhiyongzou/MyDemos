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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        NSArray *sortList = @[@1, @2, @23, @3, @33, @222, @90, @9, @79, @8];
        NSLog(@"Select Sort: %@", selectSort([sortList mutableCopy]));
    }
    return 0;
}
