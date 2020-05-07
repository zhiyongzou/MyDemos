# JPAspect
![CocoaPods Version](https://img.shields.io/cocoapods/v/JPAspect.svg?style=flat)
[![License](https://img.shields.io/github/license/zhiyongzou/JPAspect.svg?style=flat)](https://github.com/zhiyongzou/JPAspect/blob/master/LICENSE)
[![Build Status](https://travis-ci.com/zhiyongzou/JPAspect.svg?branch=master)](https://travis-ci.com/zhiyongzou/JPAspect)
[![HitCount](http://hits.dwyl.io/zhiyongzou/JPAspect.svg)](http://hits.dwyl.io/zhiyongzou/JPAspect)

JPAspect 一款基于 JSON 的 iOS 热修复框架。

你可以用 JPAspect 来更改目标方法的参数值、返回值和在目标方法调用前后插入自定义代码。

你还可以用 JPAspect 来重写简单的目标方法，但是由于 JPAspect 不支持 Block、Struct、Enum、循环语句和 C/C++ 函数，所以在方法重写上存在一定的局限性，但是用来修复 Bug 已经足够。

目前 JPAspect 支持的语法如下：

	* 任意 OC 方法调用
	* super 调用
	* 自定义局部变量
	* 赋值语句
	* if 语句：==、!=、>、>=、<、<=、||、&&
	* return 语句

## 示例
### 数组越界异常
调用 `[self outOfBoundsException:index`] 时，如果传入 `index >= self.testList.count` ，那么就会发生数组越界异常。

```objc
@implementation ViewController

- (void)outOfBoundsException:(NSUInteger)index
{
    // fix code
//    if (index >= self.testList.count) {
//        return;
//    }
    
    [self.testList objectAtIndex:index];
}

@end
```

### JSON 脚本
通过分析，需在`outOfBoundsException `调用前增加越界判断保护（示例中的注释代码）来防止崩溃。具体 JSON 修复脚本如下所示：（具体代码可参考:**[Demo](https://github.com/zhiyongzou/JPAspect/tree/master/JsonPatchDemo)**）

```objc
// 该脚本等于 fix code
{
    "Aspects": [
        {
            "className": "ViewController",
            "selName": "outOfBoundsException:",
            "hookType": 1,
            "argumentNames": ["index"],
            "customMessages" : [
                {
                    "message" : "self.testList.count",
                    "localInstanceKey" : "listCount"
                },
                {
                    "message" : "return",
                    "messageType" : 1,
                    "invokeCondition": {
                        "condition" : "index>=listCount",
                        "operator" : ">="
                    }
                }
            ]
        }
    ]
}
```

## 安装
### CocoaPods
```ruby
pod 'JPAspect'
```
### Manually
把 `JPAspect` 文件夹拷贝到工程即可

## 使用

1. `#import "JPAspect+PatchLoad.h"`
2. 获取后台下载的 JSON 修复配置
3. 调用 `+ (void)loadJsonPatchWithPath:(NSString *)filePath`

```objc
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *patchPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"json"];
    [JPAspect loadJsonPatchWithPath:patchPath];
    
    return YES;
}

@end
```

## [JPConverter](https://zhiyongzou.github.io/JPConverter/)
JPConverter 是 OC 代码转 json patch 的工具。欢迎使用，如有问题，欢迎来撩～
![](https://github.com/zhiyongzou/JPAspect/blob/master/imgs/JPConverter.jpg)

## 其他
* JPAspect 详细使用文档： [Wiki](https://github.com/zhiyongzou/JPAspect/wiki)
* JPAspect 单元测试用例：[JsonPatchDemoTests](https://github.com/zhiyongzou/JPAspect/tree/master/JsonPatchDemo/JsonPatchDemoTests) 
* 如果在使用 JPAspect 时遇到问题，请发起 **`issue`** 或联系[本人](mailto:scauzouzhiyong@163.com)
* QQ 交流群：

![](https://github.com/zhiyongzou/JPAspect/blob/master/imgs/qq_group.png)


