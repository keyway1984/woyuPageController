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
    private var titles: [String] = []   //页眉标题
    
    private lazy var pageHeaders: [UILabel] = []
    
    private lazy var pageHeaderContainer: UIScrollView = {  //页眉容器
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false

        return scrollView
    }()
    
    private lazy var underLine: UIView = {  //页眉下标
        
        let view = UIView()
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
        buildUI()
    }
}


//MARK: - 自定义初始化内容
extension PageController {
    
    //通过subViews搭建UI
    private func buildUI() {

        createPageHeaderContainer()
        createPageHeader()
        createUnderLine()
    }
    
    //创建页眉容器
    private func createPageHeaderContainer() {
        
        pageHeaderContainer.frame = self.bounds
        self.addSubview(pageHeaderContainer)
    }
    
    //创建页眉
    private func createPageHeader() {
        
        var xOffset: CGFloat = pageHeaderSpacing    //各个页眉在x方向上的偏移量
        let yOffset: CGFloat = 0    //各个页眉在y方向上的偏移量
        let widthAdd: CGFloat = 10  //页眉的宽度等于页眉标题的宽度+补正参数
        let height = self.frame.height - underLineHeight - yOffset  //页眉高度
        
        for (index, title) in titles.enumerated() {
            
            let pageHeader: UILabel = {
                
                let label = UILabel()
                
                //属性设置
                label.text = title
                label.tag = index
                label.font = UIFont.systemFont(ofSize: 13)
                label.numberOfLines = 0
                label.sizeToFit()
                label.textAlignment = .center
                label.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

                //frame设置
                label.frame = CGRect(x: xOffset, y: yOffset, width: label.frame.width + widthAdd, height: height)
                xOffset = xOffset + label.frame.width + pageHeaderSpacing
                
                return label
            }()
            
            
            pageHeaderContainer.addSubview(pageHeader)
            pageHeaders.append(pageHeader)
        }
        
        pageHeaderContainer.contentSize.width = xOffset //根据最后一个页眉x方向上的偏移量确定Container.contentSize的宽度
    }
    
    //创建页眉下标
    private func createUnderLine() {

        guard let firstPageHeader = pageHeaders.first else { return }   //获取第一个页眉
        
        //属性设置
        let xOffset: CGFloat = firstPageHeader.frame.origin.x   //x方向上的偏移量
        let yOffset: CGFloat = firstPageHeader.frame.origin.y + firstPageHeader.frame.height    //y方向上的偏移量
        let width: CGFloat = firstPageHeader.frame.width    //下标的宽度
        let height: CGFloat = underLineHeight   //下标的高度
        
        underLine.frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        self.addSubview(underLine)
    }
}
