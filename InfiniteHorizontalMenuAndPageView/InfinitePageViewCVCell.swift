//
//  CustomerHomePageOfBottomCVCell.swift
//  iTVCloud
//
//  Created by 丁偉哲 on 2017/3/24.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import UIKit
import SnapKit
class InfinitePageViewCVCell: UICollectionViewCell {
    @IBOutlet weak var view4Page: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //MARK:- 設定此部份是防止畫面剛load好時，部分頁面的frame會跑掉設定。
        if let v = view4Page.viewWithTag(100) {
            v.frame = self.view4Page.bounds
            v.snp.makeConstraints({ (m) in
                m.edges.equalToSuperview()
            })
        }
    }

}
