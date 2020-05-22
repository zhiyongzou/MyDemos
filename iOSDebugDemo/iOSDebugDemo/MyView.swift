//
//  MyView.swift
//  iOSDebugDemo
//
//  Created by zzyong on 2020/5/21.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit

enum MyError: Error {
    case MyError1
}

class MyView: UIView {

    @objc open func throwRrror() throws {
        throw MyError.MyError1;
    }
}
