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

    // 页眉控制器
    private lazy var pageHeader = PageController(viewController: self)

    // 页眉标题数据源
    private let titles: [String] = ["指定标题0", "指定标题1", "指定标题2", "指定标题3", "指定标题4", "指定标题5", "指定标题6", "指定标题7"]

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
        8
    }

    // 指定页眉
    func pageController(_: PageController, headerForPageAt index: Int) -> PageHeader {
        // 创建页眉实例
        let header = PageHeader(index, titles[index])
        // 设置页眉相关属性
        header.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        header.textTint = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        header.textTintHL = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        header.textFont = UIFont.boldSystemFont(ofSize: 13)
        header.textFontHL = UIFont.boldSystemFont(ofSize: 13)
        header.LRMargin = 8
        header.TopMargin = 1
        header.spacing = 5

        return header
    }

    // 指定页面
    func pageController(_: PageController, pageForHeaderAt index: Int) -> UIViewController {
        // 初始化ViewController
        let vc = UIViewController()
        vc.view.frame = .zero
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.backgroundColor = UIColor.random()

        // 给vc的view加入一个便于识别的label
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "~\(index)~"
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

extension ViewController: PageControllerDelegateLayout {}
