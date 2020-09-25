//
//  ViewController.swift
//  iRead
//
//  Created by zzyong on 2020/2/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import UIKit
import IRHexColor
import IRCommonLib

class ViewController: UIViewController {

    lazy var epubParser: FREpubParser = FREpubParser()
    lazy var bookCover: UIImageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookCover.contentMode = .center
        self.view.addSubview(bookCover)
        
        guard let bookPath = Bundle.main.path(forResource: "支付战争", ofType: "epub") else { return}
        guard let book: FRBook = try? epubParser.readEpub(epubPath: bookPath) else { return }
        if let coverUrl = book.coverImage?.fullHref {
            bookCover.image = UIImage.init(contentsOfFile: coverUrl)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bookCover.frame = self.view.bounds
    }
}

