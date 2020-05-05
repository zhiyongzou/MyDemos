//
//  IRLog.swift
//  IRCommonLib
//
//  Created by zzyong on 2020/5/5.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

open class IRLog: NSObject {
    
    open func sayHelloWorld() -> Void {
        print("Hello World!")
    }
    
    private func internalFunc() {
        print("internalFunc")
    }
}
