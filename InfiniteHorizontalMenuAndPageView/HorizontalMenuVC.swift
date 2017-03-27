
//
//  HorizontalMenu.swift
//  iTVCloud
//
//  Created by 丁偉哲 on 2017/3/20.
//  Copyright © 2017年 丁偉哲. All rights reserved.
//

import UIKit
extension HorizontalMenuVC : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return titles.count * defaultInfiniteValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HorizontalMenu4CVCell
        cell.label4Title.text = titles[indexPath.row % titles.count]
        cell.label4Title.tag = 100 //用來辨識變色處理
        cell.view4Line.tag = 101
        
        return cell
    }
}
extension HorizontalMenuVC : UICollectionViewDelegateFlowLayout {
    //設置集合視圖單元格大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
            return CGSize(width: (screenWidth / CGFloat(titles.count)) , height: self.collectionView.frame.height)
        
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
extension HorizontalMenuVC : UICollectionViewDelegate{
    //MARK:- 點擊的項目移動到中間的處理以及變色處理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        //print("indexPath=\(indexPath)")
        collectionView.scrollToItem(at: indexPath , at: .centeredHorizontally, animated: true)//點擊的項目移動到中間的處理
        //改變所有的cell為deSelectCellColor
        changeColor4CellsAndCurrentCell(indexPath: indexPath, cellsBGColor: deSelectCellColor, cellsTitleColor: deSelectCellTitleColor, currentCellColor: selectCellColor, currentCellTitleColor: selectCellTitleColor)
        
        //傳值給首頁去改變下面的位置
        delegate?.sendMenuIndexPath(indexPath: indexPath)
    }
    
}
//MARK:- 滾動＋拖動的項目移動到中間的處理
extension HorizontalMenuVC : UIScrollViewDelegate {
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
            delegate?.sendMenuIndexPath(indexPath: indexPath)
            
            //改變所有cell的原色為deSelectColor
            changeColor4CellsAndCurrentCell(indexPath: indexPath, cellsBGColor: deSelectCellColor, cellsTitleColor: deSelectCellTitleColor, currentCellColor: selectCellColor, currentCellTitleColor: selectCellTitleColor)
            
        }
    }
    
}

extension HorizontalMenuVC : InfinitePageViewDelegate {
    func sendPageViewIndexPath(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        //改變所有的cell為deSelectCellColor
        changeColor4CellsAndCurrentCell(indexPath: indexPath, cellsBGColor: deSelectCellColor, cellsTitleColor: deSelectCellTitleColor, currentCellColor: selectCellColor, currentCellTitleColor: selectCellTitleColor)
    }
}



protocol SelectMenuIndexPath : class {
    func  sendMenuIndexPath(indexPath:IndexPath)
}
class HorizontalMenuVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    //從首頁傳值過來時，同時設定好委派
    var infinitePageViewVC:InfinitePageViewVC!{
        didSet{
            infinitePageViewVC.delegate = self
        }
    }
    //使用者自定義的部份
    var titles = [String]()
    var selectCellColor:UIColor!//選擇到的cell顏色
    var deSelectCellColor:UIColor!//取消選擇的cell顏色
    var selectCellTitleColor:UIColor!//選擇到的title顏色
    var deSelectCellTitleColor:UIColor!//取消選擇的title顏色
    var selectCellLineColor:UIColor!//要顯示的Line的顏色
    var deSelectCellLineColor:UIColor!//取消的Line的顏色
    //用來設定傻瓜版無限滾動
    fileprivate var defaultInfiniteValue = 100
    fileprivate var defaultIndexPath:IndexPath! {
        return IndexPath(row: self.defaultInfiniteValue / 2, section: 0)
    }
    fileprivate var isInited = false // 用來控制離開此頁時，再回來因為生命週期的部份程式碼造成的小bug
    fileprivate var indexPaths: [IndexPath] = []//用來取得所有的indexPath
    //協定傳值用
    weak  var delegate:SelectMenuIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = selectCellColor
        getAllIndexPath()
    }
    
    override func viewDidLayoutSubviews() {
        if !isInited {
            //因為是傻瓜版的無限滾動，所以需要先移動到所有indexPath的中間
            collectionView.scrollToItem(at: defaultIndexPath, at: .centeredHorizontally, animated: false)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                //在畫面顯示後，讓defaultIndexPath的cell改變顏色成為選擇的顏色
                self.changeColor4CellsAndCurrentCell(indexPath: self.defaultIndexPath, cellsBGColor: self.deSelectCellColor, cellsTitleColor: self.deSelectCellTitleColor, currentCellColor: self.selectCellColor, currentCellTitleColor: self.selectCellTitleColor)
                self.isInited = true
            })
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func changeColor4CellsAndCurrentCell(indexPath:IndexPath,cellsBGColor:UIColor,cellsTitleColor:UIColor,currentCellColor:UIColor,currentCellTitleColor:UIColor){
        //改變所有的cell為deSelectCellColor
        for (_, indexPath) in indexPaths.enumerated() {
            setCellBackColorAndTitleColor(index: indexPath, cellBGColor: cellsBGColor, cellTitleColor: cellsTitleColor, cellLineColor: deSelectCellLineColor)
        }
        //處理點擊到的Cell變色處理
        setCellBackColorAndTitleColor(index: indexPath, cellBGColor: currentCellColor, cellTitleColor: currentCellTitleColor, cellLineColor: selectCellLineColor)
    }
    
    
    /// 用來改變cell background color & cell中的label background color
    ///
    /// - Parameters:
    ///   - index: <#index description#>
    ///   - cellBGColor: <#cellBGColor description#>
    ///   - cellTitleBGColor: <#cellTitleBGColor description#>
    fileprivate func setCellBackColorAndTitleColor(index:IndexPath, cellBGColor:UIColor, cellTitleColor:UIColor, cellLineColor:UIColor){
        //改變Cell Background color
        guard let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: index) else { return }
        selectedCell.contentView.backgroundColor = cellBGColor
        //改變label顏色
        guard let cell = collectionView.cellForItem(at: index) else { return }
        let label = cell.viewWithTag(100) as? UILabel
        label?.textColor = cellTitleColor
        let view4Line = cell.viewWithTag(101)
        view4Line?.backgroundColor = cellLineColor
    }
    /// 取得所有的indexPath 存到 陣列中供後續處理變色
    fileprivate func getAllIndexPath(){
        for s in 0..<collectionView.numberOfSections {
            for i in 0..<collectionView.numberOfItems(inSection: s) {
                indexPaths.append(IndexPath(row: i, section: s))
            }
        }
        
    }
    
    
}
