//
//  PageContentView.swift
//  DYLive_Swift
//
//  Created by qujiahong on 2018/6/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

import UIKit

let ContentCellID = "ContentCellID"

protocol PageContentViewDelegate : class{
    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

class PageContentView: UIView {
    // MARK: - 定义属性
    var childVCs : [UIViewController]
    weak var presentVC : UIViewController?
    var startOffsetX : CGFloat = 0
    weak var pageDelegate : PageContentViewDelegate?
    var isForbidScrollDelegate : Bool = false
    
    
    // MARK: - 懒加载属性
    lazy var collectionView : UICollectionView = {[weak self] in
        
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //创建collection
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    
    // MARK: - 自定义构造函数
    init(frame: CGRect, childVCs : [UIViewController], presentViewController: UIViewController?) {
        
        self.childVCs = childVCs
        self.presentVC = presentViewController
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension PageContentView {
    func setupUI() {
        
        //将自控制器加到父控制器中
        for childVC in childVCs {
            presentVC?.addChildViewController(childVC)
        }
        
        //添加UICollectionView，将子控制器的View放入Cell
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK: - 遵守UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        //防止循环应用，导致多次添加
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVCs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

// MARK: - 遵守UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0.是否是点击事件
        if isForbidScrollDelegate {
            return
        }
        
        //1.定义 需要获取的数据
        var progress : CGFloat = 0//滑动比例
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        let scrollViewW = scrollView.bounds.width
        
        //2.判断是 左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        if currentOffsetX > startOffsetX {
            //左滑,展示右边
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }else{
                targetIndex = sourceIndex + 1
            }
            
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            //右滑,展示左边
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }else{
                sourceIndex = targetIndex + 1
            }
        }
        //3.将progress/sourceIndex/targetIndex传递给titleView
        pageDelegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK: - 对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex : Int) {
        
        //记录需要进行执行的代理方法
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}






