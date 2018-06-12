//
//  PageTitleView.swift
//  DYLive_Swift
//
//  Created by qujiahong on 2018/6/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

import UIKit

let kScrollLineH : CGFloat = 2
let kBottomLineColor : UIColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
let kSelectColor : UIColor = UIColor(red: 255/255.0, green: 160/255.0, blue: 95/255.0, alpha: 1)

// MARK: - 联动的代理 selectIndex内部参数，index外部参数
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView : PageTitleView, selectIndex index : Int)
}

class PageTitleView: UIView {
    
    // MARK: - 定义属性
    var titles : [String]
    var currentIndex : Int = 0
    weak var pageDelegate : PageTitleViewDelegate?
    
    // MARK: - 懒加载
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    lazy var titleLabViews : [UILabel] = [UILabel]()
    
    // MARK: - 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        
        self.titles = titles
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension PageTitleView {
    
    func setupUI() {
        
        //1.UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2.添加对应title
        setupTitleLabels()
        
        //3.添加滚动滑块
        setupBottomLineAndScrollLine()
    }
    
    func setupTitleLabels() {
        
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelY : CGFloat = 0
        let labelH : CGFloat = frame.height - kScrollLineH
        
        for (index, title) in titles.enumerated() {
            
            let titleLab = UILabel()
            
            titleLab.text = title
            titleLab.tag = index
            titleLab.font = UIFont.systemFont(ofSize: 15.0)
            titleLab.textColor = UIColor.darkGray
            titleLab.textAlignment = .center
            
            let labelX : CGFloat = labelW * CGFloat(index)
            
            titleLab.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollView.addSubview(titleLab)
            titleLabViews.append(titleLab)
            
            titleLab.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabClick(tapGes:)))
            titleLab.addGestureRecognizer(tapGes)
        }
        let firstLab = titleLabViews.first
        firstLab?.textColor = UIColor.orange
        
    }
    
    func setupBottomLineAndScrollLine() {
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = kBottomLineColor
    
        let lineH : CGFloat = 0.8
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        guard let firstLab = titleLabViews.first else { return }
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLab.frame.origin.x, y: frame.height - kScrollLineH, width: firstLab.frame.width, height: kScrollLineH)
    }
}

// MARK: - 监听titleLab的点击事件,需要添加@objc
extension PageTitleView {
    @objc func titleLabClick(tapGes : UITapGestureRecognizer) {
        guard let currentLab = tapGes.view as? UILabel else { return }
        
        if currentLab.tag == currentIndex {
            return
        }
        
        let oldLab = titleLabViews[currentIndex]
        oldLab.textColor = kBottomLineColor
        currentLab.textColor = kSelectColor
        
        currentIndex = currentLab.tag
        
        let lineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.25) {
            self.scrollLine.frame.origin.x = lineX
        }
        
        //通知代理
        pageDelegate?.pageTitleView(titleView: self, selectIndex: currentIndex)
        
    }
}














