//
//  ViewController.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/7.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit

// MARK: - ViewController

class ViewController: UIViewController {
    // MARK: - 实例

    // 指定托管和数据源对象创建页眉控制器实例
    private lazy var pageHeader = PageController(viewController: self)

    // 页眉标题数据源
    private lazy var titles: [String] = {
        var result: [String] = []
        for index in 0 ... 15 {
            result.append("标题\(index)")
        }
        return result
    }()

    // MARK: - 周期函数

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageController()
    }
}

// MARK: - 构建页眉控制器相关方法

extension ViewController {
    func setupPageController() {
        view.addSubview(pageHeader)

        // 为页眉管理器指定约束
        NSLayoutConstraint.activate([
            pageHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pageHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            pageHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            pageHeader.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - PageHeaderControllerDataSource Methods

extension ViewController: PageControllerDataSource {
    // 指定页眉/页眉数量
    func pageController(_: PageController, numberOfPagesInContainer _: PageContainer) -> Int {
        16
    }

    // 定制页眉
    func pageController(_: PageController, headerForPageAt index: Int) -> PageHeader {
        // 通过指定页眉的索引和标题来创建页眉实例
        let header = PageHeader(index, titles[index])
        // 设置页眉相关属性
        header.backgroundColor = UIColor.clear
        header.textTint = #colorLiteral(red: 0.2012614608, green: 0.1959747672, blue: 0.2008952796, alpha: 1) // 页眉默认颜色
        header.textTintHL = #colorLiteral(red: 0.9979591966, green: 0.2818490267, blue: 0.1678583622, alpha: 1) // 页眉被选择后的颜色
        header.textFont = UIFont.boldSystemFont(ofSize: 15) // 页眉默认字体
        header.textFontHL = UIFont.boldSystemFont(ofSize: 15) // 页眉被选择后的字体
        header.LRMargin = 8 // 页眉和容器左右之间的距离
        header.topMargin = 3 // 页眉和容器上方的距离
        header.bottomMargin = 5 // 页眉和容器下方的距离
        header.spacing = 10 // 页眉之间的距离

        return header
    }

    // 定制页面
    func pageController(_: PageController, pageForHeaderAt index: Int) -> UIViewController {
        // 初始化ViewController
        let vc = UIViewController()
        vc.view.frame = .zero
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.backgroundColor = UIColor.random()

        // 给vc的view加入一个便于识别的label
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "页面\(index)"
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.sizeToFit()

        vc.view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
        ])

        // 将创建的vc作为当前vc的子控制器
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)

        return vc
    }
}

// MARK: - PageControllerDelegateLayout Methods

extension ViewController: PageControllerDelegateLayout {
    // 指定页眉容器的高度和背景颜色
    func pageController(_: PageController, heightOfHeaderContainer container: PageContainer) -> CGFloat {
        container.backgroundColor = UIColor.clear
        return 40
    }

    // 隐藏下标
    func pageController(_: PageController, showUnderLineForSelectedHeader line: inout PageUnderLine) -> Bool {
        
        //设置下标相关属性
        line.backgroundColor = #colorLiteral(red: 0.99063164, green: 0.2880288959, blue: 0.1035054252, alpha: 1)
        line.height = 5
        line.spacing = 0
        //切圆角
        line.layer.cornerRadius = line.height / 2
        line.layer.masksToBounds = true
        return true
    }

    // 定制右侧barItem
    func pageController(_: PageController, showRightBarItem item: inout PageRightBarItem) -> Bool {
        // 设置属性
        item.backgroundColor = UIColor.white
        item.width = 40
        // 设置阴影参数
        item.dropShadow(color: UIColor.white, opacity: 1, offset: .zero, radius: 10)
        return false
    }
}
