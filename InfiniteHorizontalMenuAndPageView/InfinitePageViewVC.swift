//
//  CustomerHomePageOfBottomVC.swift
//  iTVCloud
//
//  Created by 丁偉哲 on 2017/3/24.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import UIKit

extension InfinitePageViewVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  pageViews.count * defaultInfiniteValue
        //            //無限滾動的秘技1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! InfinitePageViewCVCell
        let view = pageViews[indexPath.row % pageViews.count]//無限滾動的秘技2
        view.tag  = 100//給view tag,用它來移除舊的view，加入新的view
        if let oldView = cell.view4Page.viewWithTag(100){
            oldView.removeFromSuperview()
        }
        cell.view4Page.addSubview(view)
        return cell
    }
}

extension InfinitePageViewVC : UICollectionViewDelegateFlowLayout {
    //設置集合視圖單元格大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
    }
    
    // 設置cell和視圖邊的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 設置每一個cell最小 行 間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 設置每一個cell的 列 間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    // 設置Header的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: 0, height: 0)
    }
    
    // 設置Footer的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: 0, height: 0)
    }
}
//MARK:- 偵測當前的PageViewIndexPath
extension InfinitePageViewVC : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkScrollViewPoint(scrollView: scrollView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkScrollViewPoint(scrollView: scrollView)
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        checkScrollViewPoint(scrollView: scrollView)
    }
    fileprivate func checkScrollViewPoint(scrollView: UIScrollView){
        if scrollView == collectionView {
            var currentCellOffset = collectionView.contentOffset
            currentCellOffset.x += collectionView.frame.size.width / 2.0
            guard let indexPath = collectionView.indexPathForItem(at: currentCellOffset) else { return }
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            //傳值給首頁去改變下面的位置
            delegate?.sendPageViewIndexPath(indexPath: indexPath)
        }
    }
}

extension InfinitePageViewVC:SelectMenuIndexPath{
    func sendMenuIndexPath(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
protocol  InfinitePageViewDelegate : class{
    func  sendPageViewIndexPath(indexPath:IndexPath)
}
class InfinitePageViewVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var storyBoardNames = [String]()
    fileprivate var pageViews = [UIView]()
    //用來設定傻瓜版無限滾動
    fileprivate var defaultInfiniteValue = 100
    fileprivate var defaultIndexPath:IndexPath! {
        return IndexPath(row: self.defaultInfiniteValue / 2, section: 0)
    }
    fileprivate var isInited = false // 防呆用
    //delegate
    var horizontalMenuVC:HorizontalMenuVC?{
        didSet{
            horizontalMenuVC?.delegate = self
        }
    }
    weak var delegate:InfinitePageViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPageVCs()
    }

    override func viewDidLayoutSubviews() {
        if !isInited{
            //因為是傻瓜版的無限滾動，所以需要先移動到所有indexPath的中間
            collectionView.scrollToItem(at: defaultIndexPath, at: .centeredHorizontally, animated: false)
            isInited = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- 實體化要加入的vc，並儲存給collectionView用
    fileprivate func initPageVCs(){
        for (_, value) in storyBoardNames.enumerated() {
            let storyboard = UIStoryboard(name: value, bundle: nil)
            let vc = storyboard.instantiateInitialViewController()!
            addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            if let subView = vc.view{
                pageViews.append(subView)
            }
        }
        collectionView.reloadData()
    }


}
