//
//  JPAspectMessage.h
//  JPAspect
//
//  Created by zzyong on 2019/5/5.
//  Copyright © 2019 zzyong. All rights reserved.
//

#import "JPAspectTypes.h"

@class JPAspectArgument;

NS_ASSUME_NONNULL_BEGIN

@interface JPAspectMessage : NSObject

/*
 自定义消息调用
 
 // OC
 [[NSAttributedString alloc] initWithString:"Hello World!"];
 
 //JSON
 "message" : "NSAttributedString.alloc.initWithString:"
 
 **/
@property (nonatomic, strong) NSString *message;

/*
 执行条件, 目前支持的运算符: ==, !=, >, >=, <, <=, ||, &&
 
 参数：
     condition    ： 条件语句
     operator     ： 运算符
     conditionKey ： 运算结果局部变量key
 
 示例1:
 // OC
 if(aString == nil) {
    [[NSAttributedString alloc] initWithString:"Hello World!"];
 }
 
 // JSON
 "message" : "NSAttributedString.alloc.initWithString:"
 "invokeCondition" : {
    "condition" : "aString==nil",
    "operator" : "=="
 }
 
 示例2:
 // OC
 if(aString == nil && bString == nil) {
    [[NSAttributedString alloc] initWithString:"Hello World!"];
 }
 
 // JSON
 "invokeCondition" : {
     "condition" : "aString==nil",
     "operator" : "==",
     "conditionKey" : "condition1"
 }
 
 "invokeCondition" : {
     "condition" : "bString==nil",
     "operator" : "==",
     "conditionKey" : "condition2"
 }
 
 "message" : "NSAttributedString.alloc.initWithString:"
 "invokeCondition" : {
     "condition" : "condition1 || condition2",
     "operator" : "||"
 }
 */
@property (nonatomic, strong) NSDictionary *invokeCondition;

/*
 消息类型，默认：JPAspectMessageTypeDefault
 
//======JPAspectMessageTypeReturn======//
 
 返回语句规则：
    1、无返回值：return
    2、有返回值：return=type:value
 
 参数
     type  ：变量类型（JPArgumentType）
     value ：返回值。目前支持字符串、基础C变量、自定义本地局部变量
 
 // OC
 return;

 // JSON
 "message" : "return"
 
 // OC
 return YES;

 // JSON: return=JPArgumentType:value
 "message" : "return=3:1"

 
//======JPAspectMessageTypeAssign======//
 
 赋值语句规则：
    instanceName=type:value
 
 参数
     instanceName ：变量名
     type  ：变量类型（JPArgumentType）
     value ：返回值。目前支持字符串、基础C变量、自定义本地局部变量

 
 // OC
 BOOL a = YES;
 
 // JSON: instanceName=JPArgumentType:value
 "message":"a=3:1"
 
 **/
@property (nonatomic, assign) JPAspectMessageType messageType;

/*
 消息参数
 
 参数：
     index ：参数位置
     type  ：参数类型（JPArgumentType）
     value ：参数值

 // OC
 Hello World!
 
 // JSON
 {
     "initWithString:" : [
         {
            "index" : 0,
            "type"  : JPArgumentType,
            "value" : "Hello World!"
         }
     ]
 }
 **/
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<NSDictionary *> *> *parameters;
/// 参数 Model 缓存
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<JPAspectArgument *> *> *aspectArgumentParameters;

/*
 局部变量索引: 赋值、判断
 
 // OC
 NSAttributedString *att = [[NSAttributedString alloc] initWithString:"Hello World!"];
 if (att == nil) {
     return;
 }
 
 // JSON
 {
     "selName": "XXSel:",
     "className": "XXClass",
     "hookType": 3, // JPAspectHookCustomInvokeBefore
     "customInvokeMessages" : [
         {
             "message" : "NSAttributedString.alloc.initWithString:",
             "localInstanceKey" : "att"
         },
         {
             "message" : "return",
             "messageType":2,
             "invokeCondition" : {
                 "condition" : "att==nil",
                 "operator" : "=="
             }
         }
     ]
 }
 **/
@property (nonatomic, strong, nullable) NSString *localInstanceKey;


+ (instancetype)modelWithMessageDictionary:(NSDictionary *)messageDic;

@end

NS_ASSUME_NONNULL_END

