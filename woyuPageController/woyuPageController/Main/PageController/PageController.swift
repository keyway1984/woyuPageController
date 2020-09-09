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

//DataSource
protocol PageHeaderControllerDataSource: class {
    func setPageHeaderTitles() -> [String]
}


//MARK: - PageController类定义
class PageController: UIView {
    
    
    //MARK: - 公开属性
    
    //UI参数
    var underLineHeight: CGFloat = 10   //下标的默认高度
    var underLineSpacing: CGFloat = 5   //下标和页眉间的间距
    var pageHeaderSpacing: CGFloat = 10  //页眉的间距
    
    //代理引用
    weak var dataSource: PageHeaderControllerDataSource?
    
    
    //MARK: - 私有属性
    //页眉标题集合
    private var titles: [String]
    
    //页眉集合
    private lazy var pageHeaders: [PageHeader] = []
    
    //页眉容器
    private lazy var pageHeaderContainer: UIScrollView = {
        
        //frame设置
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        //属性设置
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false

        return scrollView
    }()
    
    //页眉下标
    private lazy var underLine: UIView = {
        
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
    init(delegate: PageHeaderControllerDataSource) {
        self.dataSource = delegate
        self.titles = []
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        buildSubViews()
    }

    //必要构造器
    //从 xib 或者 storyboard中构造
    required init?(coder: NSCoder) {
        self.titles = ["标题233"]
        super.init(coder: coder)
        buildSubViews()
    }
    
    //便利构造器
    convenience init() {
        self.init(pageHeaderTitles: [])
    }
}


//MARK: - subViews的初始化内容
extension PageController {
    
    //通过subViews搭建UI
    private func buildSubViews() {
        createPageHeaderContainer()
        createPageHeader()
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
    private func createPageHeader() {
        
        var xOffset: CGFloat = pageHeaderSpacing    //各个页眉在x方向上的偏移量
        let yOffset: CGFloat = 0    //各个页眉在y方向上的偏移量
        var textWidth: CGFloat = 0  //页眉标题宽度
        let widthAdd: CGFloat = 10  //页眉宽度补正
        
        //从代理函数中获取页眉标题数据源
        if let titles = dataSource?.setPageHeaderTitles() { self.titles = titles }
        
        //根据标题初始化页眉
        for (index, title) in titles.enumerated() {
            
            let pageHeader = PageHeader(index, title)
            textWidth = pageHeader.textWidth
            
            pageHeader.delegate = self
            
            pageHeaderContainer.addSubview(pageHeader)
            pageHeaders.append(pageHeader)
            
            //设置autolayout参数
            NSLayoutConstraint.activate([
                pageHeader.leadingAnchor.constraint(equalTo: pageHeaderContainer.leadingAnchor, constant: xOffset),
                pageHeader.topAnchor.constraint(equalTo: pageHeaderContainer.topAnchor, constant: yOffset),
                pageHeader.widthAnchor.constraint(equalToConstant: textWidth + widthAdd),
                pageHeader.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -underLineHeight - yOffset - underLineSpacing)
            ])
            
            //更新xOffset
            xOffset = xOffset + textWidth + widthAdd + pageHeaderSpacing
        }
        
        pageHeaderContainer.contentSize.width = xOffset //根据最后一个页眉x方向上的偏移量确定Container.contentSize的宽度
    }
    
    
    //创建页眉下标
    private func createUnderLine() {

        guard let firstPageHeader = pageHeaders.first else { return }   //获取第一个页眉
        
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




extension PageController: PageHeaderDelegate {
    func PageHeaderIsClicked(_ pageHeader: PageHeader, index: Int) {
        print(index)
    }
    
    
}
