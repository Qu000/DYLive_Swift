//
//  HomeViewController.swift
//  DYLive_Swift
//
//  Created by qujiahong on 2018/6/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

import UIKit

let kTitleViewH : CGFloat = 40


class HomeViewController: UIViewController {

    // MARK: - 懒加载属性
    lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH+kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.pageDelegate = self
        return titleView
    }()
    
    lazy var pageContentView : PageContentView = {[weak self] in
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y: kStatusBarH+kNavigationBarH+kTitleViewH, width: kScreenW, height: contentH)
        
        var childVCs = [UIViewController]()
        childVCs.append(RecommendViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomcolor()
            childVCs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVCs: childVCs, presentViewController: self)
        contentView.pageDelegate = self
        return contentView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }


}

// MARK: - extension - 设置UI界面
extension HomeViewController {
    func setupUI() {
        //0.不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //1.导航
        setupNavigationBar()
        
        //2.titleView
        view.addSubview(pageTitleView)
        
        //3.pageContentVC
        view.addSubview(pageContentView)
    }
    private func setupNavigationBar() {
        
        //左
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: "logo"), for: .normal)
        leftBtn.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        //右
        let btnSize = CGSize(width: 40, height: 40)
        /*
         //类方法
         let historyItem = UIBarButtonItem.createItem(imageName: "Image_my_history", highImageName: "Image_my_history_click", itemSize: btnSize)
         */
        
        //构造方法
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", itemSize: btnSize)
        
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", itemSize: btnSize)
        
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", itemSize: btnSize)
        
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}

// MARK: - 遵守PageTitleView的代理
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
    
}
// MARK: - 遵守PageContentView的代理
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    
}



