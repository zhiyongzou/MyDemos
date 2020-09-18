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

// switch 支持任意类型的数据以及各种比较操作——不仅仅是整数以及测试相等。
let vegetable = "red pepper"
switch vegetable {
case "celery":
    print("Add some raisins and make ants on a log.")
case "cucumber", "watercress":
    print("That would make a good tea sandwich.")
case let x where x.hasSuffix("pepper"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tastes good in soup.")
}

// for-in 遍历字典
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
var kindName: String?
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
            kindName = kind;
        }
    }
}
print(largest)
print(kindName ?? "")

// 使用 while 来重复运行一段代码直到条件改变。循环条件也可以在结尾，保证能至少循环一次
var n = 2
while n < 100 {
    n *= 2
}
print(n)

var m = 2
repeat {
    m *= 2
} while m < 100
print(m)

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

// 使用 func 来声明一个函数，使用名字和参数来调用函数。使用 -> 来指定函数返回值的类型
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet(person:"Bob", day: "Tuesday")

// 默认情况下，函数使用它们的参数名称作为它们参数的标签，在参数名称前可以自定义参数标签，或者使用 _ 表示不使用参数标签。
func greet(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet("John", on: "Wednesday")

// 使用元组来生成复合值，比如让一个函数返回多个值。该元组的元素可以用名称或数字来获取。
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0

    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }

    return (min, max, sum)
}
let statistics = calculateStatistics(scores:[5, 3, 100, 3, 9])
print(statistics.sum)
print(statistics.2)

// 函数可以嵌套。被嵌套的函数可以访问外侧函数的变量，你可以使用嵌套函数来重构一个太长或者太复杂的函数。
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()

// 函数是第一等类型，这意味着函数可以作为另一个函数的返回值
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

// 函数也可以当做参数传入另一个函数。
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers2 = [20, 19, 7, 12]
hasAnyMatches(list: numbers2, condition: lessThanTen)

print(numbers2.map { (number: Int) -> Int in
    let result = 3 * number
    return result
})

let sortedNumbers = numbers2.sorted()
print(sortedNumbers)

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

// 泛型
// 在尖括号里写一个名字来创建一个泛型函数或者类型
// 泛型函数

func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}
makeArray(repeating: "knock", numberOfTimes: 4)

// 你也可以创建泛型函数、方法、类、枚举和结构体。
// 重新实现 Swift 标准库中的可选类型
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}
var possibleInteger: OptionalValue<Int> = .none
possibleInteger = .some(100)

// 在类型名后面使用 where 来指定对类型的一系列需求，比如，限定类型实现某一个协议，限定两个类型是相同的，或者限定某个类必须有一个特定的父类。
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Element: Equatable, T.Element == U.Element
{
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    return false
}
anyCommonElements([1, 2, 3], [3])

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


// 对象和类
// 使用 class 和类名来创建一个类
class Shape {
    var numberOfSides = 0
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

// 要创建一个类的实例，在类名后面加上括号。使用点语法来访问实例的属性和方法
var shape = Shape()
shape.numberOfSides = 7
var shapeDescription = shape.simpleDescription()

// 使用 init 来创建一个构造器。
// 使用 deinit 创建一个析构函数
class NamedShape {
    open var numberOfSides: Int = 0
    var name: String?

    init(name: String) {
        self.name = name
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
    
    deinit {
        self.name = nil
    }
}

// 子类的定义方法是在它们的类名后面加上父类的名字，用冒号分割。
// 创建类的时候并不需要一个标准的根类，所以你可以根据需要添加或者忽略父类。
// 子类如果要重写父类的方法的话，需要用 override 标记
class Square: NamedShape {
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    
    var height: CGFloat {
        get {
            return 1.0;
        }
    }
        
    func area() ->  Double {
        return sideLength * sideLength
    }

    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}
let test = Square(sideLength: 5.2, name: "my test square")
test.area()
test.simpleDescription()

// getter 和 setter
// setter 中，新值的名字是 newValue
class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 3
    }

    var perimeter: Double {
        get {
            return 3.0 * sideLength
        }
        set {
            sideLength = newValue / 3.0
        }
    }

    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle")
print(triangle.perimeter)
triangle.perimeter = 9.9
print(triangle.sideLength)

// 使用 willSet 和 didSet。写入的代码会在属性值发生改变时调用，但不包含构造器中发生值改变的情况
class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        willSet {
            square.sideLength = newValue.sideLength
            print("triangle willSet");
        }
    }
    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
            print("square willSet");
        }
    }
    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
print(triangleAndSquare.square.sideLength)
print(triangleAndSquare.triangle.sideLength)
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
print(triangleAndSquare.triangle.sideLength)

// 枚举和结构体
// 使用 enum 来创建一个枚举。就像类和其他所有命名类型一样，枚举可以包含方法
enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    
    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.ace
let aceRawValue = ace.rawValue
print(ace)
print(aceRawValue)

if let convertedRank = Rank(rawValue: 3) {
    let threeDescription = convertedRank.simpleDescription()
    print(threeDescription)
}

// 枚举的关联值是实际值，并不是原始值的另一种表达方法。实际上，如果没有比较有意义的原始值，你就不需要提供原始值。
enum Suit {
    case spades, hearts, diamonds, clubs
    
    func simpleDescription() -> String {
        switch self {
        case .spades:
            return "spades"
        case .hearts:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
    
    func color() -> String {
        switch self {
        case .spades, .clubs:
            return "black"
        default:
            return "red"
        }
    }
}
let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()
hearts.color()

// 如果枚举成员的实例有原始值，那么这些值是在声明的时候就已经决定了，这意味着不同枚举实例的枚举成员总会有一个相同的原始值。当然我们也可以为枚举成员设定关联值，关联值是在创建实例时决定的。这意味着同一枚举成员不同实例的关联值可以不相同
enum ServerResponse {
    case result(String, String)
    case failure(String)
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

switch success {
    case let .result(sunrise, sunset):
        print("Sunrise is at \(sunrise) and sunset is at \(sunset)")
    case let .failure(message):
        print("Failure...  \(message)")
}

// 使用 struct 来创建一个结构体。结构体和类有很多相同的地方，包括方法和构造器。它们之间最大的一个区别就是结构体是传值，类是传引用
struct Card {
    var rank: Rank
    var suit: Suit
    var name: String?
    
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}
var threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()
threeOfSpades.name = "iOS"
var altThree = threeOfSpades
altThree.name = "json"
print(threeOfSpades.name!, altThree.name!)

// 协议和扩展
// 使用 protocol 来声明一个协议
// mutating 关键字修饰方法是为了能在该方法中修改 struct 或是 enum 的变量
protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

// 类、枚举和结构体都可以遵循协议。
class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
    }
}
var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
}
var b = SimpleStructure()
b.adjust()
let bDescription = b.simpleDescription

// 使用 extension 来为现有的类型添加功能，比如新的方法和计算属性
extension Int: ExampleProtocol {
    var simpleDescription: String {
        return "The number \(self)"
    }
    mutating func adjust() {
        self += 42
    }
}
print(7.simpleDescription)

// 你可以像使用其他命名类型一样使用协议名——例如，创建一个有不同类型但是都实现一个协议的对象集合。当你处理类型是协议的值时，协议外定义的方法不可用
let protocolValue: ExampleProtocol = a
print(protocolValue.simpleDescription)
//print(protocolValue.anotherProperty)  // 去掉注释可以看到错误

// 错误处理
// 使用 Error 协议的类型来表示错误。
enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

// 使用 throw 来抛出一个错误和使用 throws 来表示一个可以抛出错误的函数。如果在函数中抛出一个错误，这个函数会立刻返回并且调用该函数的代码会进行错误处理。
func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner
    } else if printerName == "Gutenberg" {
        throw PrinterError.onFire
    }
    return "Job sent"
}

// 有多种方式可以用来进行错误处理。一种方式是使用 do-catch
do {
    let printerResponse = try send(job: 1040, toPrinter: "Never Has Toner")
    print(printerResponse)
} catch {
    print(error)
}

// 可以使用多个 catch 块来处理特定的错误。参照 switch 中的 case 风格来写 catch
do {
    let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
    print(printerResponse)
} catch PrinterError.onFire {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}

// 另一种处理错误的方式使用 try? 将结果转换为可选的。如果函数抛出错误，该错误会被抛弃并且结果为 nil。否则，结果会是一个包含函数返回值的可选值
let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")
print(printerSuccess as Any, printerFailure as Any)

let i666ui = try? send(job: 999, toPrinter: "Never Has Toner")
print(i666ui ?? "oooo")

// 使用 defer 代码块来表示在函数返回前，函数中最后执行的代码。无论函数是否会抛出错误，这段代码都将执行
var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]

func fridgeContains(_ food: String) -> Bool {
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }

    let result = fridgeContent.contains(food)
    return result
}
fridgeContains("banana")
print(fridgeIsOpen)


// convenience
// convenience 的初始化方法不能被子类重写或者是从子类中以 super 的方式被调用
class People {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    convenience init(nickname: String) {
        self.init(name: nickname)
    }
}


