//
//  InfiniteHorizontalMenuAndInfinteHorizontaPageView.swift
//  iTVCloud
//
//  Created by 丁偉哲 on 2017/3/27.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class InfiniteHorizontalMenuAndInfinteHorizontaPageView {
    //view4HorizontalMenu 加入 HorizontalMenu用
    var horizontalMenuTitles = [String]()
    fileprivate var horizontalMenuStoryBoardName = "HorizontalMenu"
    fileprivate var horizontalMenuVC:HorizontalMenuVC?
    //view4Bottom 加入InfinitePageViewVC用
    var storyBoardNames = [String]()
    fileprivate var customerHomePageOfBottomStoryBoardName = "InfinitePageView"
    fileprivate var infinitePageViewVC:InfinitePageViewVC?
    
    //要加入的vc
    fileprivate var parentViewController : UIViewController?
    
    init(viewController:UIViewController) {
        parentViewController = viewController
        initInfiniteHorizontalMenuAndInfinteHorizontaPageView()
    }
    
    fileprivate func initInfiniteHorizontalMenuAndInfinteHorizontaPageView(){
        horizontalMenuVC = initHorizontalMenu()
        infinitePageViewVC = initInfinitePageViewVC()
    }
    
    //MARK:- 實體化水平菜單
    fileprivate func initHorizontalMenu() -> HorizontalMenuVC?{
        let storyboard = UIStoryboard(name: horizontalMenuStoryBoardName, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        guard let  infinitePageViewVC = vc as? HorizontalMenuVC else { return nil}
         return infinitePageViewVC
    }
    
    /// 要先使用initHorizontalMenu()、initCustomerHomePageOfBottom()後才可以使用此方法
    ///
    /// - Parameter viewController: <#viewController description#>
    func addHorizontalMenuToSelf(with view4HorizontalMenu:UIView, horizontalMenuTitles:[String], selectCellColor:UIColor, deSelectCellColor:UIColor, selectCellTitleColor:UIColor, deSelectCellTitleColor:UIColor, selectCellLineColor:UIColor, deSelectCellLineColor:UIColor){
        guard let vc = parentViewController else {  return  }
        guard let horizontalMenuVC = horizontalMenuVC else { return  }
        vc.addChildViewController(horizontalMenuVC)
        //傳值進去
        horizontalMenuVC.infinitePageViewVC = infinitePageViewVC
        horizontalMenuVC.titles = horizontalMenuTitles
        horizontalMenuVC.selectCellColor = selectCellColor
        horizontalMenuVC.deSelectCellColor = deSelectCellColor
        horizontalMenuVC.selectCellTitleColor = selectCellTitleColor
        horizontalMenuVC.deSelectCellTitleColor = deSelectCellTitleColor
        horizontalMenuVC.selectCellLineColor = selectCellLineColor
        horizontalMenuVC.deSelectCellLineColor  = deSelectCellLineColor
        
        view4HorizontalMenu.addSubview(horizontalMenuVC.view)
        horizontalMenuVC.view.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        horizontalMenuVC.didMove(toParentViewController: parentViewController)
    }
    
    //MARK:- 實體化下半部
    fileprivate func initInfinitePageViewVC() -> InfinitePageViewVC?{
        let storyboard = UIStoryboard(name: customerHomePageOfBottomStoryBoardName, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        guard let  infinitePageViewVC = vc as? InfinitePageViewVC else { return nil}
        return infinitePageViewVC
    }
    
    func addInfinitePage(with view4Bottom:UIView, storyBoardNames:[String]){
        guard let vc = parentViewController else {  return  }
        guard let infinitePageViewVC = infinitePageViewVC else { return }
        vc.addChildViewController(infinitePageViewVC)
        //傳值進去
        infinitePageViewVC.storyBoardNames = storyBoardNames
        infinitePageViewVC.horizontalMenuVC = horizontalMenuVC
        
        view4Bottom.addSubview(infinitePageViewVC.view)
        infinitePageViewVC.view.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        infinitePageViewVC.didMove(toParentViewController: parentViewController)
    }

}
