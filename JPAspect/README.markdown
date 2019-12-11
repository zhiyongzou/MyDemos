# JPAspect
JPAspect 一款轻量级、无侵入和无审核风险的 iOS 热修复组件。JPAspect 通过下发指定规则的 JSON 即可轻松实现线上 Bug 修复。 

## 功能
* 方法替换为空实现
* 方法参数修改
* 方法返回值修改
* 方法调用前后插入自定义代码
	* 支持任意 OC 方法调用
	* 支持赋值语句
	* 支持 if 语句
	* 支持 super 调用
	* 支持自定义局部变量
	* 支持 return 语句

## 示例
### 数组越界崩溃
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
```objc
{
    "AspectDefineClass" : [],
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
### 方案一
1. `#import "JPAspect.h"` 
2. 设置使用到的 **Class** `+ (void)setupAspectDefineClass:(NSArray<NSString *> *)classList`
3. 解析 JSON 拿到对应的 Aspect Dictionary，然后调用 `+ (void)hookSelectorWithAspectDictionary:(NSDictionary *)aspectDictionary`

```objc
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *patchDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:@".../xxx.json"] options:NSJSONReadingMutableContainers error:NULL];
    
    [JPAspect setupAspectDefineClass:[patchDic objectForKey:@"AspectDefineClass"]];

    NSArray<NSDictionary *> *patchs = [patchDic objectForKey:@"Aspects"];
    [patchs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull patch, NSUInteger idx, BOOL * _Nonnull stop) {
        [JPAspect hookSelectorWithAspectDictionary:patch];
    }];
    
    return YES;
}

@end
```

### 方案二
1. `#import "JPAspect+PatchLoad.h"`
2. 调用 `+ (void)loadJsonPatchWithPath:(NSString *)filePath`

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

### JPAspect 详细使用文档请移步 ==> [Wiki]()

