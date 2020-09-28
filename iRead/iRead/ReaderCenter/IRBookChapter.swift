//
//  IRBookChapter.swift
//  iRead
//
//  Created by zzyong on 2020/9/28.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRCommonLib

class IRBookChapter: NSObject {
    /// 章节页列表
    lazy var pages = [IRBookPage]()
    /// 章节标题
    var title: String?
    /// 章节索引
    var chapterIndex = 1
    
    public convenience init(withTocRefrence refrence: FRTocReference, chapterIndex: Int = 1) {
        self.init()
        
        guard let fullHref = refrence.resource?.fullHref else { return }
        guard let htmlData = NSData.init(contentsOf: URL.init(fileURLWithPath: fullHref)) else { return }
        print(htmlData)
    }
}
