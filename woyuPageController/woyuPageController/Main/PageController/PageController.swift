//
//  PageController.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/7.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import Foundation
import UIKit

//MARK: - 相关协议
//数据源
protocol PageHeaderControllerDataSource: class {
    //获取页眉标题字符串组
    func SetPageHeaderTitlesTo(_ pageController: PageController, pageHeaders: [PageHeader]) -> [String]
}

//交互通知
protocol PageControllerDelegate: class {
    //    //通知选中当前页眉
    //    func pageController(_ pageController: PageController, selectCurrent pageHeader: PageHeader)
}


//MARK: - PageController类定义
class PageController: UIView {
    
    
    //MARK: - 公开属性
    //UI参数
    var underLineHeight: CGFloat = 10   //下标的默认高度
    var underLineSpacing: CGFloat = 5   //下标和页眉间的间距
    var pageHeaderSpacing: CGFloat = 10  //页眉之间的间距
    var pageHeaderLRMargin: CGFloat = 20  //页眉和容器左右两边的边距
    var pageHeaderTopMargin: CGFloat = 0    //页眉和容器上面的边距
    
    
    //代理引用
    weak var dataSource: PageHeaderControllerDataSource?
    weak var delegate: PageControllerDelegate?
    
    
    //MARK: - 私有属性
    //状态参数
    private var titles: [String]    //页眉标题集合
    private lazy var pageHeaders: [PageHeader] = [] //页眉集合
    private var currentIndex: Int = -1 //当前已选中的页眉的索引
    
    
    //子View实例
    private lazy var pageHeaderContainer: UIScrollView = {  //容器
        
        //frame设置
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        //属性设置
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    
    private lazy var underLine: UIView = {  //页眉下标
        
        //frame设置
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        //属性设置
        view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
        return view
    }()
    
    
    //MARK: - 构造器
    //指定构造器
    //通过指定页眉标题构造
    init(pageHeaderTitles: [String]) {
        self.titles = pageHeaderTitles
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        buildSubViews()
    }
    
    //通过指定托管对象构造（需遵从相关协议）
    init(dataSource: PageHeaderControllerDataSource) {
        self.dataSource = dataSource
        self.titles = []
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        buildSubViews()
    }
    
    //必要构造器
    //从 xib 或者 storyboard中构造
    required init?(coder: NSCoder) {
        
        let ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "woyuViewController")
        if let dataSource = ViewController as? PageHeaderControllerDataSource { self.dataSource = dataSource }
        
        self.titles = Array(repeating: "storyboard自动创建的页眉标题", count: 5)
        super.init(coder: coder)
        buildSubViews()
    }
    
    //便利构造器
    //自动创建复数个相同的标题
    convenience init() {
        let titles: [String] = Array(repeating: "自动创建的页眉标题", count: 5)
        self.init(pageHeaderTitles: titles)
    }
}


//MARK: - 子view构建相关方法
extension PageController {
    
    //UI搭建
    private func buildSubViews() {
        createPageHeaderContainer()
        createPageHeaders()
        createUnderLine()
    }
    
    
    //创建页眉容器
    private func createPageHeaderContainer() {
        
        self.addSubview(pageHeaderContainer)
        
        //autolayout设置
        NSLayoutConstraint.activate([
            pageHeaderContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pageHeaderContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pageHeaderContainer.topAnchor.constraint(equalTo: self.topAnchor),
            pageHeaderContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    
    //创建页眉
    private func createPageHeaders() {
        
        var textSize: CGSize = .zero  //页眉标题宽度
        
        //从代理函数中获取页眉标题数据源
        if let titles = dataSource?.SetPageHeaderTitlesTo(self, pageHeaders: pageHeaders) { self.titles = titles }
        
        //根据标题初始化页眉
        for (index, title) in titles.enumerated() {
            
            //创建页眉
            let pageHeader = PageHeader(index, title)
            textSize = pageHeader.textSize
            pageHeader.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            
            //设置页眉手势
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.pageHeaderGestureResponder(_:)))
            tapGesture.numberOfTapsRequired = 1
            pageHeader.addGestureRecognizer(tapGesture)
            pageHeader.isUserInteractionEnabled = true
            
            //添加页眉进容器
            pageHeaderContainer.addSubview(pageHeader)
            
            //设置页眉约束
            if let prePageHeader = pageHeaders.last {
                //对其它页眉
                pageHeader.leadingAnchor.constraint(equalTo: prePageHeader.trailingAnchor, constant: pageHeaderSpacing, identifier: "leading").isActive = true
            } else {
                //对于第一个页眉
                pageHeader.leadingAnchor.constraint(equalTo: pageHeaderContainer.leadingAnchor, constant: pageHeaderLRMargin, identifier: "leading").isActive = true
            }
            
            NSLayoutConstraint.activate([
                pageHeader.topAnchor.constraint(equalTo: pageHeaderContainer.topAnchor, constant: pageHeaderTopMargin, identifier: "top"),
                pageHeader.widthAnchor.constraint(equalToConstant: textSize.width, identifier: "width"),
                pageHeader.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -underLineHeight - pageHeaderTopMargin - underLineSpacing, identifier: "height")
            ])
            
            //添加页眉进集合
            pageHeaders.append(pageHeader)
        }
        
        //对容器的contentSize进行约束
        if let lastPageHeader = pageHeaders.last {
            
            lastPageHeader.trailingAnchor.constraint(equalTo: pageHeaderContainer.trailingAnchor, constant: -pageHeaderLRMargin).isActive = true
        }
    }
    
    
    //创建页眉下标
    private func createUnderLine() {
        
        guard let firstPageHeader = pageHeaders.first else { return }   //获取第一个页眉
        pageHeaderSwitcher(switchTo: firstPageHeader.index)
        
        pageHeaderContainer.addSubview(underLine)
        
        //设置autolayout参数
        NSLayoutConstraint.activate([
            underLine.topAnchor.constraint(equalTo: firstPageHeader.bottomAnchor, constant: underLineSpacing),
            underLine.leadingAnchor.constraint(equalTo: firstPageHeader.leadingAnchor, constant: 0),
            underLine.widthAnchor.constraint(equalTo: firstPageHeader.widthAnchor, constant: 0),
            underLine.heightAnchor.constraint(equalToConstant: underLineHeight)
        ])
    }
}



//MARK: - UI相关方法
extension PageController {
    
    //手势反馈
    @objc private func pageHeaderGestureResponder(_ sender: UITapGestureRecognizer) {
        
        guard let selectedHeader = sender.view as? PageHeader else { return }
        
        pageHeaderSwitcher(switchTo: selectedHeader.index)
    }
    
    //页眉切换器
    private func pageHeaderSwitcher(switchTo targetIndex: Int) {
        
        if targetIndex != currentIndex {
            headerSelectStateManager(selection: targetIndex)
            headerSizeAdjuster(sizing: targetIndex)
        }
        
        currentIndex = targetIndex  //记录新选中的页眉索引
    }
    
    //管理页眉的选中状态
    private func headerSelectStateManager(selection targetIndex: Int) {
        
        if currentIndex >= 0 { pageHeaders[currentIndex].isSelected = false }
        pageHeaders[targetIndex].isSelected = true
    }
    
    //根据选中后的页眉字体动态调整页眉的大小
    private func headerSizeAdjuster(sizing targetIndex: Int) {
        
        if currentIndex >= 0 { pageHeaders[currentIndex].constraint(withIdentify: "width")?.constant = pageHeaders[currentIndex].textSize.width }
        pageHeaders[targetIndex].constraint(withIdentify: "width")?.constant = pageHeaders[targetIndex].textSize.width
        
        layoutIfNeeded()
    }
}

