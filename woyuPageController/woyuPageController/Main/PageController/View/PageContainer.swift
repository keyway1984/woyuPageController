//
//  PageContainer.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/17.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit

// MARK: - 容器类

class PageContainer: UIScrollView {
    // MARK: - 公开属性

    var height: CGFloat = 0

    // MARK: - 构造器

    // 指定构造器
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
    }

    // 必要构造器
    // 当前类不支持从xib 或者 storyboard 构造
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
