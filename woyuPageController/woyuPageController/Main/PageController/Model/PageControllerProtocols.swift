//
//  PageControllerProtocols.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/17.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import Foundation
import UIKit

// MARK: - PageController相关协议

// 数据源
protocol PageControllerDataSource: AnyObject {
    // 指定页眉/页面数量
    func pageController(_ controller: PageController, numberOfPagesInContainer: PageContainer) -> Int

    // 获取初始化创建的页眉
    func pageController(_ controller: PageController, headerForPageAt index: Int) -> PageHeader
    
    //获取初始化创建的页面
    func pageController(_ controller: PageController, pageForHeaderAt index: Int) -> UIViewController
}

// UI布局
protocol PageControllerDelegateLayout: AnyObject {
    // 指定页眉容器高度
    func pageController(_: PageController, heightOfHeaderContainer container: PageContainer) -> CGFloat
    // 设置页眉下标是否显示/定制页眉下标
    func pageController(_ controller: PageController, showUnderLineForSelectedHeader line: inout PageUnderLine) -> Bool
}

// MARK: - 协议方法的默认实现

// UI布局
extension PageControllerDelegateLayout {
    // 页眉容器的默认高度
    func pageController(_: PageController, heightOfHeaderContainer container: PageContainer) -> CGFloat {
        container.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return 40
    }

    // 设置页眉下标
    func pageController(_: PageController, showUnderLineForSelectedHeader line: inout PageUnderLine) -> Bool {
        // 切圆角
        line.layer.cornerRadius = line.height / 2
        line.layer.masksToBounds = true
        // 设置颜色
        line.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)

        return true
    }
}
