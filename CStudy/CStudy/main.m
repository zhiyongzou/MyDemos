//
//  main.m
//  CStudy
//
//  Created by zzyong on 2020/5/17.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 动态内存分配
 */
void memoryTest()
{
    // malloc 和 free
    // malloc：动态内存分配；其分配的是一块连续的内存。返回 NULL 代表内存分配失败
    //free：内存释放
    
    
    //
}


/**
 C 数组
 */
void arrayTest()
{
    // 整数占4个字节
    int d = 0;
    long longNum = 0;
    NSLog(@"int: %lu long: %lu", sizeof(d), sizeof(longNum));
    
    int array[] = {123, 33, 52, 71, 94};
    // 在 C 中，在几乎所有使用数组名的表达式中，数组名的值是指一个指针常量，也就是数组第一个元素的地址。
    // 等价于 int *firstNum = &array[0];
    int *firstNum = array;
    NSLog(@"firstNum: %d", *firstNum);
    
    // 只有在两种场合下，数组名并不用指针常量来表示—就是当数组名作为 sizeof 操作符或者单目操作符 & 的操作数时。
    unsigned long arraySize = sizeof(array);
    NSLog(@"arraySize: %lu", arraySize);
    
    int arrayB[5];
    // 不能使用赋值运算符把一个数组的所有元素复制到另外一个数组，必须使用循环。
//    arrayB = array; // error
    for (int idx = 0; idx < 5; idx++) {
        arrayB[idx] = array[idx];
    }
    NSLog(@"arrayB firstNum: %d", arrayB[0]);
    
    int *ap = array + 2; // equal to arrzy[2]
    NSLog(@"ap: %d subscribe取值：%d", *ap, array[2]);
    
    // 指针加 1，指向 arrzy[3]
    ap += 1;
    NSLog(@"ap: %d ", *ap);
    
    // 指针表达式代替数组下标引用
    // 当前 ap 指针指向位置，即 arrzy[3]
    NSLog(@"ap: %d ", ap[0]);
    // 前一个元素的值，即 arrzy[2]
    NSLog(@"ap: %d ", ap[-1]);
    // 指向后一个元素，即 arrzy[4]
    NSLog(@"ap: %d ", ap[1]);
    // 指向 arrzy[5]，数组越界
    NSLog(@"ap: %d ", ap[2]);
    
    
}

/**
 goto 语句:  适用于跳出多层嵌套循环
 */
void gotoFunc(int num)
{
    while (num > 10) {
        while (num < 5) {
            while (num > 3) {
                if (num == 2) {
                    // 此处 break 只影响包含它的最内层循环
                    // break;
                    goto breakLoop;
                }
                num--;
            }
            num--;
        }
        num--;
        NSLog(@"breakLoop failed");
    }
    
breakLoop:
    NSLog(@"breakLoop success");
}

int main(int argc, const char * argv[]) {
    
//    gotoFunc(3);
//    arrayTest();
//    memoryTest();
    
    NSArray *arr = @[@0, @1, @2, @3];
    NSLog(@"%@", [arr subarrayWithRange:NSMakeRange(2+1, arr.count - 2 - 1)]);
    
    return 0;
}



