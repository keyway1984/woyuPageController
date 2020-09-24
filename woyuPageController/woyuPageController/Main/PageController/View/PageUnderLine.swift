//
//  UnderLine.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/17.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit

// MARK: - 下标类

class PageUnderLine: UIView {
    // MARK: - 公有属性

    var height: CGFloat = 6 // 下标的默认高度
    var spacing: CGFloat = 5 // 下标和页眉间的间距

    // MARK: - 构造器

    // 指定构造器
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    // 必要构造器
    // 当前类不支持从xib 或者 storyboard 构造
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
