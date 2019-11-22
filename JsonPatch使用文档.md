## 简介
### JsonPatch 目前已有功能

* 方法替换为空实现
* 方法参数修改
* 方法返回值修改
* 方法前后插入自定义代码
	* 支持任意OC方法调用
	* 支持赋值语句
	* 支持 if 语句
	* 支持 super 调用
	* 支持自定义局部变量
	* 支持 return 语句

### JSON 脚本字段说明
#### 1. 示例脚本
在 `- (void)viewWillDisappear:` 方法调用后增加自定义 `self.view.backgroundColor = [UIColor redColor]` 	方法调用; 该方法执行的条件是：**`animated == YES`**

```
{
    "AspectClassDefineList" : ["UIColor"],
    "Aspects": [
        {
            "selName" : "viewWillDisappear:",
            "hookType" : 4,
            "className" : "ViewController",
            "parameterNames" : ["animated"],
            "customInvokeMessages" : [
                {
                    "message" : "UIColor.redColor",
                    "messageType" : 0,
                    "localInstanceKey" : "redColor",
                    "invokeCondition": {
                    						"condition" : "animated==1",
                    						"operator" : "==",
                    						"conditionKey" : "isAnimated"
                    					}
                },
                {
                    "message" : "self.view.setBackgroundColor:",
                    "messageType" : 0,
                    "parameters" : {
                        "setBackgroundColor:" : [{
                            "index" : 0,
                            "value" : "redColor",
                            "type"  : 1
                        }],
                    "invokeCondition": {
                    						"conditionKey" : "isAnimated"
                    				   }
                    }
                }
            ],
            "ApplySystemVersions": [
                "*"
            ]
        }
    ]
}
```

#### 2. 主要字段说明

##### AspectClassDefineList ---> [ "Class", "Class2", ... ]
	Objective-C 所使用到类，可选字段，如有使用到OC类，那么必须先定义后使用；多个类使用 “,” 分隔

##### Aspects ---> [ {dictionary}, {dictionary2}, ... ]
	需要替换的方法，必选字段，数组中的一个 {dictionary}（以下称为 Aspect） 代表一个需要替换的方法

##### Aspect 字段说明
> **className**：

	方法所属类名，必选字段；例如：ViewController
 
> **selName**：

	需要替换的方法名，必选字段；例如：viewWillDisappear:
 
> **hookType**：

	方法替换类型，必选字段；例如：CCAspectHookNullImp、CCAspectHookCustomInvokeBefore等，具体看 CCAspectHookType
 
> **parameterNames**：

	方法参数列表，可选字段，无参数可不填；如果方法有多个参数，那么参数列表的顺序和个数必须跟方法的参数一致。
	例如：`- (id)performSelector:(SEL)aSelector withObject:(id)object` 的参数列表为: ["aSelector", "object"]
 
> **customInvokeMessages**：

	自定义方法调用列表，必选字段

> **ApplySystemVersions**：

	适用系统版本，简单使用 * 跟数字进行组合，可指定多个，可选字段，nil 代表全部版本；例如： ["*"] : 代表全部版本，
	["8.*"] : 代表适用于 iOS8，[ "8.1.0", "9.*"] : 适用于 iOS8.1.0 和 iOS9

#####  Message 字段说明
> **message**：

	自定义方法调用，必选字段；例如："self.view.setBackgroundColor:"
 
> **messageType**：

	方法类型，必选字段，默认 CCAspectMessageTypeDefault；有以下3种 CCAspectMessageType：
	
	* 方法调用（ CCAspectMessageTypeDefault = 0 ）
	* 返回语句（ CCAspectMessageTypeReturn  = 1 ）
	* 赋值语句（ CCAspectMessageTypeAssign  = 2 ）

> **parameters**：

	方法参数；可选字段，无参数不用填写。格式为：{"方法名(SEL)" : [{参数},  ...], {"方法名1(SEL1)" : [{参数1},  ...], ...}
	参数有以下3个字段：
	
	* index ：参数位置，index 起始计数为 0
	* type  ：参数类型（具体可参考：CCArgumentType）
	* value ：参数值
   
> **localInstanceKey**：

	方法局部变量 Key，可选字段, 如 nil 则表示无需保留该变量; 该局部变量可以作为其他方法的参数、条件判断参数和方法返回值；
	示例中的`redColor`则为下一个方法调用的参数

> **invokeCondition**：

	方法执行条件，可选字段；目前支持：==、!=、>、>=、<、<=、||、&&；有以下3个字段：
	【注意】:如 conditionKey 已存在，那么condition 和 operator 可以不填写
	 
	* condition ：条件语句
	* operator  ：运算符
	* conditionKey ：运算结果局部变量key，如 nil 则表示无需保留当前结果
 
## 使用
### 一、方法调用
#### Objective-C 类定义：**`AspectClassDefineList`**
```
// 使用 UIColor 类
"AspectClassDefineList" : ["UIColor"]
```
#### 类方法调用
```
// OC
[UIColor redColor];

// JSON
"message" : "UIColor.redColor"
```
#### 实例方法调用
```
// OC
[[UIView alloc] init];

// JSON
"message" : "UIView.alloc.init"
```
#### 带参数方法调用
```
// OC
self.view.backgroundColor = [UIColor redColor];

// JSON
{
    "message" : "UIColor.redColor",
    "localInstanceKey" : "redColor" // 保留作为下一个方法的参数
},
{
    "message" : "self.view.setBackgroundColor:",
    "parameters" : {
        "setBackgroundColor:" : [{
            "index" : 0,
            "value" : "redColor",
            "type"  : 1
        }]
    }
}
```
#### 多参数方法调用
```
// OC
[UIColor colorWithWhite:0 alpha:0.1];

// JSON
{
    "message" : "UIColor.colorWithWhite:alpha:",
    "parameters" : {
        "colorWithWhite:alpha:" : [{
            "index" : 0,
            "value" : 0,
            "type"  : 11
        },
        {
            "index" : 1,
            "value" : 0.1,
            "type"  : 11
        }]
    }
}
```
#### 带参数方法多级调用
```
// OC
[[[NSMutableAttributedString alloc] initWithString:@"Hello World"] appendAttributedString:[[NSAttributedString alloc] initWithString:@"!"]]

//JSON
{
    "message" : "NSAttributedString.alloc.initWithString:",
    "parameters" : {
	        "initWithString:" : [{
	            "index" : 0,
	            "value" : "!",
	            "type"  : 1
	        }]
	 },
    "localInstanceKey" : "otherAttributedString" // 保留作为下一个方法的参数
},

{
	"message" : "NSMutableAttributedString.alloc.initWithString:.appendAttributedString:"
	"parameters" : {
	        "initWithString:" : [{
	            "index" : 0,
	            "value" : "Hello World",
	            "type"  : 1
	        }],
	        "appendAttributedString:" : [{
	            "index" : 0,
	            "value" : "otherAttributedString",
	            "type"  : 1
	        }]
	    }
}
```

#### Get 方法替换 
* **完全替换**：CCAspectHookCustomInvokeInstead

```objc
// OC
- (NSString *)aspectTitle
{
    if (!_aspectTitle) {
        _aspectTitle = @"AspectTitle";
    }
    
    return _aspectTitle;
}

// JSON
// 1. 使用 valueForKey: 获取变量值
{
    "message" : "self.valueForKey:",
    "parameters" : {
        "valueForKey:" : [{
            "index" : 0,
            "value" : "aspectTitle",
            "type"  : 1
        }]
    },
    "localInstanceKey" : "aspectTitleValue"
},

// 2. 如果 aspectTitleValue == nil 则 调用 setValue:forKey: 进行赋值
{
    "message" : "self.setValue:forKey:",
    "parameters" : {
        "setValue:forKey:" : [{
            "index" : 0,
            "value" : "Hello World!",
            "type"  : 1
        },
        {
        	  "index" : 1,
            "value" : "aspectTitle",
            "type"  : 1
        }]
    },
    "invokeCondition": {
    						"condition" : "aspectTitleValue==nil",
    						"operator" : "=="
                    	}
},

// 3. 首次调用 aspectTitleValue 无值，因此需要再次调用 valueForKey:
{
    "message" : "self.valueForKey:",
    "parameters" : {
        "valueForKey:" : [{
            "index" : 0,
            "value" : "aspectTitle",
            "type"  : 1
        }]
    },
    "localInstanceKey" : "aspectTitleValue",
    "invokeCondition": {
    						"condition" : "aspectTitleValue==nil",
    						"operator" : "=="
                    	}
},
// 4. 返回变量值
{
    "message" : "return=1:aspectTitleValue",
    "messageType" : 1
}
```

* **方法调用前进行赋值，适用于已自定义 get 方法**：CCAspectHookCustomInvokeBefore

```objc
// OC
- (NSString *)aspectTitle
{
    if (!_aspectTitle) {
        _aspectTitle = @"AspectTitle";
    }
    
    return _aspectTitle;
}

// JSON
// 1. 使用 valueForKey: 获取变量值
{
    "message" : "self.valueForKey:",
    "parameters" : {
        "valueForKey:" : [{
            "index" : 0,
            "value" : "aspectTitle",
            "type"  : 1
        }]
    },
    "localInstanceKey" : "aspectTitleValue"
},

// 2. 如果 aspectTitleValue == nil 则 调用 setValue:forKey: 进行赋值
{
    "message" : "self.setValue:forKey:",
    "parameters" : {
        "setValue:forKey:" : [{
            "index" : 0,
            "value" : "Hello World!",
            "type"  : 1
        },
        {
			"index" : 1,
			"value" : "aspectTitle",
			"type"  : 1
        }]
    },
    "invokeCondition": {
    						"condition" : "aspectTitleValue==nil",
    						"operator" : "=="
                    	}
}
```

### 二、方法参数

目前已支持参数类型如下

```objc
typedef NS_ENUM(NSUInteger, CCArgumentType) {
    
    CCArgumentTypeUnknown           = 0,
    CCArgumentTypeObject            = 1, // id
    CCArgumentTypeClass             = 2,
    CCArgumentTypeBool              = 3,
    CCArgumentTypeLong              = 4, // NSInteger
    CCArgumentTypeUnsignedLong      = 5, // NSUInteger
    CCArgumentTypeShort             = 6,
    CCArgumentTypeUnsignedShort     = 7,
    CCArgumentTypeLongLong          = 8,
    CCArgumentTypeUnsignedLongLong  = 9,
    CCArgumentTypeFloat             = 10,
    CCArgumentTypeDouble            = 11, // CGFolat
    CCArgumentTypeInt               = 12,
    CCArgumentTypeUnsignedInt       = 13,
    CCArgumentTypeSEL               = 14,
    CCArgumentTypeCGSize            = 15,
    CCArgumentTypeCGPoint           = 16,
    CCArgumentTypeCGRect            = 17,
    CCArgumentTypeUIEdgeInsets      = 18
};
```

#### 1. NSString
```objc
// OC

@"Hello World!";

// JSON
{
	"index" : 0,
	"type"  : 1, //CCArgumentTypeObject
	"value" : "Hello World!"
}
```
#### 2. Class

```objc
// OC
NSAttributedString

//JSON
{
	"index" : 0,
	"type"  : 2, //CCArgumentTypeClass
	"value" : "NSAttributedString"
}
```
#### 3. SEL

```objc
// OC
@selector(initWithString:)

//JSON
{
	"index" : 0,
	"type"  : 14, //CCArgumentTypeSEL
	"value" : "initWithString:"
}
```

#### 4. 基本类型(int、double、long、BOOL、CGFloat、...)

```objc
// OC
int a = 1;

// JSON
{
	"index" : 0,
	"type"  : 12, //CCArgumentTypeInt
	"value" : 1
}
```

#### 5. UI布局参数：CGRect、CGPoint、CGSize、UIEdgeInsets，使用 “ , ” 符号分割

```objc
// OC
CGRectMake(0, 0, 1, 1.1);

// JSON
{
	"index" : 0,
	"type"  : 17, //CCArgumentTypeCGRect
	"value" : "0,0,1,1.1"
}
```

#### 6. 方法局部变量，使用 localInstanceKey 取值

```objc
// OC
[UIColor redColor]

// JSON: 要获取 redColor，必须先生成局部变量再使用
{
   // 生成 redColor 局部变量
    "message" : "UIColor.redColor",
    "messageType" : 0,
    "localInstanceKey" : "redColor"
}，
{
	"index" : 0,
	"type"  : 1, //CCArgumentTypeObject
	"value" : "redColor" // 使用 redColor 索引取值
}
```

### 三、返回语句
#### 1. 返回语句作用
* 是否退出当前方法
* 更改返回值

#### 2. 返回语句格式
* 无返回值：`return`
* 有返回值：`return=type:value`
	* `type`  ：变量类型。具体定义看：**`CCArgumentType`**
	* `value` ：返回值。支持字符串、基本类型（int, long, float, ...）、局部变量（localInstanceKey）

#### 3. 使用示例
* 无返回值

```objc
// OC 
return;

// JSON
"mesage" : "return",
"messageType" : 1 // CCAspectMessageTypeReturn
```

* 基本类型返回值

```objc
// OC 
return YES;

// JSON
"mesage" : "return=3:1",
"messageType" : 1 // CCAspectMessageTypeReturn
```

* UI布局类型返回值

```objc
// OC 
return CGRectMake(0, 0, 1, 1.1);

// JSON
"mesage" : "return=17:0,0,1,1.1",
"messageType" : 1 // CCAspectMessageTypeReturn
```

* 局部变量返回值

```objc
// OC 
return [UIColor redColor];

// JSON: 要返回 redColor，必须先生成局部变量再使用
{
   // 生成 redColor 局部变量
    "message" : "UIColor.redColor",
    "messageType" : 0,
    "localInstanceKey" : "redColor"
}，
{
	"mesage" : "return=1:redColor",
	"messageType" : 1 // CCAspectMessageTypeReturn
}
```

* 条件返回语句

```objc
// OC
if (animated) {
	return;
}

// JSON
{
    "message" : "return",
    "messageType" : 1,
    "invokeCondition" : {"condition":"animated==1","operator":"=="}
}
```
### 四、赋值语句
#### 1. 赋值语句作用
* 更改方法参数值（主要）
* 创建局部变量

#### 2. 赋值语句格式
* `instanceName=type:value`
	* `instanceName` ：变量名：方法参数名、局部变量名（localInstanceKey）
	* `type`  ：变量类型。具体定义看：**`CCArgumentType`**
	* `value` ：变量值。支持字符串、基本类型（int, long, float, ...）、局部变量（localInstanceKey）

#### 3. 使用示例
* 更改方法参数值

```objc
// OC
- (void)viewWillDisappear:(BOOL)animated
{
    // 脚本增加
//    animated = NO;
    [super viewWillDisappear:animated];
}

// JSON
{
    "selName" : "viewWillDisappear:",
    "hookType" : 3, // CCAspectHookCustomInvokeBefore
    "className" : "ViewController",
    "parameterNames" : ["animated"],
    "customInvokeMessages" : [
        {
            "message" : "animated=3:0"
        }
    ]
}
```

* 创建局部变量

```objc
// OC 
BOOL isAnimated = YES;

// JSON
"message" : "isAnimated=3:1"
```

## 注意
1. 执行条件（invokeCondition）均适用于以上三种语句
2. 替换的方法时需要评估该方法的调用频次，调用频次过高（ >1000/s ）的请考虑替换其他方法
3. 禁止替换高频次调用的系统方法。例如：`NSNumber` 的 `- (BOOL)isEqualToNumber:(NSNumber *)number;`
4. 语句（message）中注意不要有多余的空格，例如：`"message" : "isAnimated =3:1"` （ = 号前有多余空格）