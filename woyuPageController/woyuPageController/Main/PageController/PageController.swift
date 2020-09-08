//
//  PageController.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/7.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import Foundation
import UIKit



class PageController: UIView {
    
    //MARK: - 公开属性
    var width: CGFloat = UIView.layoutFittingExpandedSize.width   //页眉管理器的默认宽度
    var height: CGFloat = 40    //页眉管理器的默认高度
    var underLineHeight: CGFloat = 10   //下标的默认高度
    var pageHeaderSpacing: CGFloat = 10  //页眉的间距

    
    //MARK: - 私有属性
    //页眉标题集合
    private var titles: [String] = []
    
    //页眉集合
    private lazy var pageHeaders: [UILabel] = []
    
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
    //指定frame构造
    init(frame: CGRect, pageHeaderTitles: [String]) {
        self.titles = pageHeaderTitles
        super.init(frame: frame)
        commonInit()
    }
    
    //从 xib 或者 storyboard中构造
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }


    //其它构造函数
    private func commonInit() {
        buildSubViews()
    }
}


//MARK: - 自定义初始化内容
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
        var width: CGFloat = 0  //页眉宽度（自适应为与text等宽）
        let widthAdd: CGFloat = 10  //页眉宽度补正
        let height = self.frame.height - underLineHeight - yOffset  //页眉高度

        for (index, title) in titles.enumerated() {
            
            let pageHeader: UILabel = {
                
                //frame设置
                let label = UILabel(frame: .zero)
                label.translatesAutoresizingMaskIntoConstraints = false

                //属性设置
                label.text = title
                label.tag = index
                label.font = UIFont.systemFont(ofSize: 13)
                label.numberOfLines = 0
                label.sizeToFit()
                width = label.frame.width
                label.textAlignment = .center
                label.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                
                return label
            }()

            pageHeaderContainer.addSubview(pageHeader)
            
            //设置autolayout参数
            NSLayoutConstraint.activate([
                
                pageHeader.leadingAnchor.constraint(equalTo: pageHeaderContainer.leadingAnchor, constant: xOffset),
                pageHeader.topAnchor.constraint(equalTo: pageHeaderContainer.topAnchor, constant: yOffset),
                pageHeader.widthAnchor.constraint(equalToConstant: width + widthAdd),
                pageHeader.heightAnchor.constraint(equalToConstant: height)
            
            ])
            
            //更新xOffset
            xOffset = xOffset + width + widthAdd + pageHeaderSpacing
            pageHeaders.append(pageHeader)
        }
        
        pageHeaderContainer.contentSize.width = xOffset //根据最后一个页眉x方向上的偏移量确定Container.contentSize的宽度
    }
    
    //创建页眉下标
    private func createUnderLine() {

        guard let firstPageHeader = pageHeaders.first else { return }   //获取第一个页眉
        
        self.addSubview(underLine)
        
        //设置autolayout参数
        NSLayoutConstraint.activate([
            
            underLine.topAnchor.constraint(equalTo: firstPageHeader.bottomAnchor, constant: 0),
            underLine.leadingAnchor.constraint(equalTo: firstPageHeader.leadingAnchor, constant: 0),
            underLine.widthAnchor.constraint(equalTo: firstPageHeader.widthAnchor, constant: 0),
            underLine.heightAnchor.constraint(equalToConstant: underLineHeight)
        ])
    }
}
