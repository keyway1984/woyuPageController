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
    //下标
    var removeUnderLine: Bool {                                                 //设置下标是否移除
        get { return self.contains(self.underLine) }
        set {
            if newValue {
                self.underLine.removeFromSuperview()
                self.container.constraints.forEach {
                    if $0.identifier == "headerHeight" { $0.constant = -headerTopMargin }
                }
            }
        }
    }
    
    var lineTint: UIColor? {                                                    //设置下标颜色
        get { return self.underLine.backgroundColor }
        set { self.underLine.backgroundColor = newValue }
    }
    
    var lineFilletedRadius: Bool {                                               //设置下标边框是否切圆角
        get { return self.underLine.layer.cornerRadius > 0 }
        set {
            self.underLine.layer.cornerRadius = (newValue ? lineHeight/2 : 0)
            self.underLine.layer.masksToBounds = newValue
        }
    }
    
    //页眉
    var headerTint: UIColor {                                                      //设置页眉背景颜色
        get { return self.headerDefaultTint }
        set {
            self.headerDefaultTint = newValue
            self.headers.forEach { $0.backgroundColor = newValue } }
    }
    
    // TODO: 还要追加几个计算属性用于便捷设置页眉字体的选中和非选中效果
    
    
    
    //代理引用
    weak var dataSource: PageHeaderControllerDataSource?
    weak var delegate: PageControllerDelegate?
    
    
    //MARK: - 私有属性
    //UI参数
    //下标
    private var lineHeight: CGFloat = 6            //下标的默认高度
    private var lineSpacing: CGFloat = 5           //下标和页眉间的间距
    private var lineDefaultTint: UIColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    
    //页眉
    private var headerSpacing: CGFloat = 10         //页眉之间的间距
    private var headerLRMargin: CGFloat = 20        //页眉和容器左右两边的边距
    private var headerTopMargin: CGFloat = 0        //页眉和容器上面的边距
    private var headerDefaultTint: UIColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    //容器
    private var containerDefaultTint: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)         //容器背景颜色
    
    
    //状态参数
    //页眉
    private var titles: [String]                                //页眉标题集合
    private lazy var headers: [PageHeader] = []                //页眉集合
    private var currentHeaderIndex: Int = -1                             //当前已选中的页眉的索引
    
    
    //子View实例
    private lazy var container: UIScrollView = {          //容器
        
        //frame设置
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        //属性设置
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = containerDefaultTint
        
        return scrollView
    }()
    
    private lazy var underLine: UIView = {                          //页眉下标
        
        //frame设置
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        //属性设置
        view.backgroundColor = lineDefaultTint
        
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
        
        // FIXME: 只能手动输入storyboard name和所属ViewController的identify，待修复完善..
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
        
        self.addSubview(container)
        
        //autolayout设置
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    
    //创建页眉
    private func createPageHeaders() {
        
        //从代理函数中获取页眉标题数据源
        if let titles = dataSource?.SetPageHeaderTitlesTo(self, pageHeaders: headers) { self.titles = titles }
        
        //根据标题初始化页眉
        for (index, title) in titles.enumerated() {
            
            //创建页眉
            let pageHeader = PageHeader(index, title)
            
            //设置页眉属性
            pageHeader.backgroundColor = headerDefaultTint
            
            //设置页眉手势
            setupGesture(to: pageHeader)
            
            //添加页眉进容器
            container.addSubview(pageHeader)
            
            //设置页眉约束
            if let prePageHeader = headers.last {
                //对其它页眉
                pageHeader.leadingAnchor.constraint(equalTo: prePageHeader.trailingAnchor, constant: headerSpacing, identifier: "headerLeading").isActive = true
            } else {
                //对于第一个页眉
                pageHeader.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: headerLRMargin, identifier: "headerLeading").isActive = true
            }
            
            NSLayoutConstraint.activate([
                pageHeader.topAnchor.constraint(equalTo: container.topAnchor, constant: headerTopMargin, identifier: "headerTop"),
                pageHeader.widthAnchor.constraint(equalToConstant: pageHeader.textSize.width, identifier: "headerWidth"),
                pageHeader.heightAnchor.constraint(equalTo: container.heightAnchor, constant: -lineHeight - headerTopMargin - lineSpacing, identifier: "headerHeight")
            ])
            
            //添加页眉进集合
            headers.append(pageHeader)
        }
        
        //对容器的contentSize进行约束
        if let lastPageHeader = headers.last {
            
            lastPageHeader.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -headerLRMargin).isActive = true
        }
    }
    
    
    //创建页眉下标
    private func createUnderLine() {
        
        guard let firstPageHeader = headers.first else { return }   //获取第一个页眉
        pageHeaderSwitcher(switchTo: firstPageHeader.index)
        
        //切圆角
        underLine.layer.cornerRadius = lineHeight / 2
        underLine.layer.masksToBounds = true
        
        container.addSubview(underLine)
        
        //设置autolayout参数
        NSLayoutConstraint.activate([
            underLine.topAnchor.constraint(equalTo: firstPageHeader.bottomAnchor, constant: lineSpacing, identifier: "lineTop"),
            underLine.centerXAnchor.constraint(equalTo: firstPageHeader.centerXAnchor, constant: 0, identifier: "lineCenterX"),
            underLine.widthAnchor.constraint(equalTo: firstPageHeader.widthAnchor, constant: 0, identifier: "lineWidth"),
            underLine.heightAnchor.constraint(equalToConstant: lineHeight, identifier: "lineHeight")
        ])
    }
}


//MARK: - 交互相关方法
extension PageController {
    
    //设置手势
    private func setupGesture(to target: PageHeader) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.pageHeaderGestureResponder(_:)))
        tapGesture.numberOfTapsRequired = 1
        target.addGestureRecognizer(tapGesture)
        target.isUserInteractionEnabled = true
    }
    
    //手势反馈
    @objc private func pageHeaderGestureResponder(_ sender: UITapGestureRecognizer) {
        
        guard let selectedHeader = sender.view as? PageHeader else { return }
        
        pageHeaderSwitcher(switchTo: selectedHeader.index)
    }
}



//MARK: - UI相关方法
extension PageController {
    
    //页眉切换器
    private func pageHeaderSwitcher(switchTo targetIndex: Int) {
        
        if targetIndex != currentHeaderIndex {
            
            headerSelectStateManager(selection: targetIndex)
            headerSizeAdjuster(sizing: targetIndex)
            
            currentHeaderIndex = targetIndex  //记录新选中的页眉索引
        }
    }
    
    //管理页眉的选中状态
    private func headerSelectStateManager(selection targetIndex: Int) {
        
        if currentHeaderIndex >= 0 { headers[currentHeaderIndex].isSelected = false }
        headers[targetIndex].isSelected = true
    }
    
    //根据选中后的页眉字体动态调整页眉的大小
    private func headerSizeAdjuster(sizing targetIndex: Int) {
        
        if currentHeaderIndex >= 0 { headers[currentHeaderIndex].constraint(withIdentify: "headerWidth")?.constant = headers[currentHeaderIndex].textSize.width }
        headers[targetIndex].constraint(withIdentify: "headerWidth")?.constant = headers[targetIndex].textSize.width
        
        layoutIfNeeded()
    }
}

