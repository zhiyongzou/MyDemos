//
//  IRBookCell.swift
//  iRead
//
//  Created by zzyong on 2020/9/25.
//  Copyright © 2020 zzyong. All rights reserved.
//

import IRCommonLib

/// 书封面比例(width/height)
let bookCoverScale = 0.67

class IRBookCell: UICollectionViewCell {
    
    var bookCoverView: UIImageView!
    var progressLabel: UILabel!
    var optionButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bookCoverView.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.width / 0.67)
        
        let progressY = self.bookCoverView.frame.maxY
        
        self.progressLabel.frame = CGRect.init(x: 0, y: progressY, width: 60, height: 40)
    }
    
    // MARK: - Private
    
    func setupSubviews() {
        bookCoverView = UIImageView.init()
        bookCoverView.contentMode = .scaleAspectFit
        self.contentView.addSubview(bookCoverView)
        
        progressLabel = UILabel.init()
        progressLabel.text = "10%"
        progressLabel.textColor = UIColor.hexColor("666666")
        progressLabel.font = UIFont.systemFont(ofSize: 13)
        progressLabel.textAlignment = .left
        self.contentView.addSubview(progressLabel)
    }
    
    // MARK: - Public
}
