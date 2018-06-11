//
//  PageContentView.swift
//  DYLive_Swift
//
//  Created by qujiahong on 2018/6/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

import UIKit

let ContentCellID = "ContentCellID"


class PageContentView: UIView {
    // MARK: - 定义属性
    let childVCs : [UIViewController]
    let presentVC : UIViewController
    
    // MARK: - 懒加载属性
    lazy var collectionView : UICollectionView = {
        
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //创建collection
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    
    // MARK: - 自定义构造函数
    init(frame: CGRect, childVCs : [UIViewController], presentViewController: UIViewController) {
        
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
            presentVC.addChildViewController(childVC)
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









