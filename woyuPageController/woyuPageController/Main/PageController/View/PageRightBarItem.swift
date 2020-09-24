//
//  PageRightBarItem.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/21.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit

// MARK: - 页眉控制器右侧按钮类

class PageRightBarItem: UIView {
    // MARK: - 公有属性

    var width: CGFloat = 0  //barItem的宽度

    // MARK: - 私有属性

    private lazy var barItemBody: UIImageView = { // item主体
        // frame设置
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // 属性设置
        imageView.image = UIImage(systemName: "list.triangle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.sizeToFit()

        return imageView
    }()

    // MARK: - 构造器

    // 指定构造器
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildSubViews()
    }

    // 必须构造器
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 子View构建相关方法

extension PageRightBarItem {
    // UI搭建
    private func buildSubViews() {
        createBarItemBody()
    }

    // 创建item主体
    private func createBarItemBody() {
        addSubview(barItemBody)

        // autolayout约束设置
        NSLayoutConstraint.activate([
            barItemBody.centerYAnchor.constraint(equalTo: centerYAnchor),
            barItemBody.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
    }
}
