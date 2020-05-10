import UIKit

var str = "Hello, playground"

// 用 let 关键字声明常量， 标示符后面的冒号（ : ）表明该其类型
let language: String = "Swift"
let isHidden: Bool = true

// Swift 可以自动推断其类型, 无需指定
// 自动推断为 Bool 类型
let isAwesome = true

// 常量值不可改变
// Cannot assign to value: 'width' is a 'let' constant
// width = 2

// 变量声明
var version = 1;

// 字符串串拼接
let confrence = "WWDC"
let year = 2020

// + 只适用于拼接字符串，不能拼接其它类型，例如：int
var message = "Hello" + " " + confrence

// 可以用 \(var) 拼接其它类型
message = "Hello, \(confrence) \(year)"

// 括号里面还可以是表达式
message = "Hello, \(confrence) \(year + 1)"

// 使用括号创建 [] 数组和字典
let names: [String] = ["Lily", "Tom", "Aday", "Amy", "Jack"]
let ages = ["Lily": 18, "Amy": 20]

// for 循环
// ... 闭合运算符
for number in 1...5 {
    print("\(number) times 4 is \(number * 4)")
}

// ..< 半闭合运算符
let reults = [1, 33, 45, 66, 88, 978, 90, 4, 8, 80, 3]
let maxResultCount = 5
for index in 0..<maxResultCount {
    print("Result \(index) is \(reults[index])")
}

// 直接遍历数组
for name in ["Lily", "Tom", "Aday"] {
    print("Hello \(name)!")
}

for name in names {
    print("Hello \(name)!")
}

// 同时遍历字典的 key value
// () 元组
for (name, age) in ages {
    print("\(name) is \(age) years old")
}

var packingList = ["Socks", "Shoes"]

let age = ages["zzy"]

if age == nil {
    print("age is not found")
}

if let age = ages["Amy"] {
    print("An age of \(age) was found.")
}

func sendMessage(_ message: String, to recipient: String, shouting: Bool = false) {
    var msg = "\(message), \(recipient)"
    if shouting {
        msg = msg.uppercased()
    }
    print(msg)
}

sendMessage("Hello", to: "Amy", shouting: true)

sendMessage("Hello", to: "Tom")

// 遍历字符串字符
let dogString: String = "Dog?!🐶"
for character in dogString {
    print(character)
}

func firstString(havingprefix prefix: String, in strings: [String]) -> String?
{
    for string in strings {
        if string.hasPrefix(prefix) {
            return string
        }
    }
    
    return nil
}

var guests = ["Jack", "Kumar", "Anita", "Anna"]

if let guest = firstString(havingprefix: "A", in: guests) {
    print("See you at the party, \(guest)")
} else {
    print("Invite must be in the mail")
}


/*
 闭包：Closures

 格式：(parater types ) -> return type
 
 函数所对应的闭包格式栗子
 函数：func sendMessge() {...}
 闭包：() -> Void
 
 函数：func firstString(havingprefix prefix: String, in strings: [String]) -> String? {...}
 闭包：(String, [String]) -> String?
 
*/

func filterInts(_ numbers: [Int], _ includeNumber: (Int) -> Bool) -> [Int] {
    var result: [Int] = []
    for number in numbers {
        if includeNumber(number) {
            result.append(number)
        }
    }
    
    return result
}


let numbers = [4, 17, 20, 77, 82, 97]
func divisibleByTwo(_ number: Int) -> Bool {
    return number % 2 == 0
}

// 传入函数名
var evenNumbers = filterInts(numbers, divisibleByTwo)
print(evenNumbers)

// 闭包的语法跟函数申明很像，它没有名字，需要把整个闭包函数写在大括号 {} 中,
// 还要用 in 关键字把闭包函数体和签名区分开。其他跟函数一致
// 具体实现如下
evenNumbers = filterInts(numbers, { (number: Int) -> Bool in return number % 2 == 0 })
print(evenNumbers)

// Swift 可以自动推断函数参数类型及返回值类型
evenNumbers = filterInts(numbers, { number in return number % 2 == 0 })
print(evenNumbers)

// 如果闭包实现只是一个返回语句，你甚至可以省略 return 关键字
evenNumbers = filterInts(numbers, { number in number % 2 == 0 })
print(evenNumbers)

// Swift 有提供隐式变量名，使用美元符号开始：$， 用数字代表参数位置，例如 $0 表示闭包的第一个参数 $1是第二个参数等等
// 所以闭包可直接省略参数名和 in 关键字
evenNumbers = filterInts(numbers, { $0 % 2 == 0 })
print(evenNumbers)

// Trailing Closures: 尾随闭包
// 当闭包是最后一个参数参数时，你可以写一个尾随闭包
evenNumbers = filterInts(numbers) { number in
    
    return number % 2 == 0
}
print(evenNumbers)

evenNumbers = filterInts([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) { (number) -> Bool in
    return number % 2 == 0
}
print(evenNumbers)


// 泛型函数
func filter<Element>(_ source: [Element], _ includeElement: (Element) -> Bool) -> [Element] {
    var result: [Element] = []
    for element in source {
        if includeElement(element) {
            result.append(element)
        }
    }
    return result
}

print(filter(guests, { (string) -> Bool in
    return string.count > 4
}))


// 结构体
