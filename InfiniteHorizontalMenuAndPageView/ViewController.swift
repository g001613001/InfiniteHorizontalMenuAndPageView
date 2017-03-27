//
//  ViewController.swift
//  InfiniteHorizontalMenuAndPageView
//
//  Created by 丁偉哲 on 2017/3/27.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var view4HorizontalMenu: UIView!
    @IBOutlet weak var view4Page: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setInfiniteHorizontalMenuAndInfinteHorizontaPageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- 實體化無限水平菜單＆無限水平PageView
    fileprivate func setInfiniteHorizontalMenuAndInfinteHorizontaPageView(){
        let vc = InfiniteHorizontalMenuAndInfinteHorizontaPageView(viewController: self)
        vc.addHorizontalMenuToSelf(with:view4HorizontalMenu, horizontalMenuTitles: ["皮神","小火龍","傑尼龜","妙蛙種子"],  selectCellColor: .orange, deSelectCellColor: .orange, selectCellTitleColor: .white, deSelectCellTitleColor: .gray, selectCellLineColor: .white, deSelectCellLineColor: .clear)
        vc.addInfinitePage(with: view4Page, storyBoardNames:  ["VC1","VC2","VC3","VC4"])
    }


}

