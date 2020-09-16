//
//  PageController.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/7.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 相关协议

// 数据源
protocol PageControllerDataSource: AnyObject {
    // 指定页眉/页面数量
    func pageController(_ controller: PageController, numberOfPagesInContainer: UIScrollView) -> Int

    // 获取初始化创建的页眉
    func pageController(_ controller: PageController, headerForPageAt index: Int) -> PageHeader
}

// 交互通知
protocol PageControllerDelegate: AnyObject {
    //    //通知选中当前页眉
    //    func pageController(_ pageController: PageController, selectCurrent pageHeader: PageHeader)
}

// MARK: - PageController类定义

class PageController: UIView {
    // MARK: - 公开属性

    // UI参数
    // 下标
    var removeUnderLine: Bool { // 设置下标是否移除
        get { contains(underLine) }
        set {
            if newValue {
                underLine.removeFromSuperview()
                headerContainer.constraints.forEach { // 注意子view引用其它view实现的约束在运行时都会算作父view的约束
                    if $0.identifier == "headerHeight" { $0.constant = -headerTopMargin }
                }
            }
        }
    }

    var lineTint: UIColor? { // 设置下标颜色
        get { underLine.backgroundColor }
        set { underLine.backgroundColor = newValue }
    }

    var lineFilletedRadius: Bool { // 设置下标边框是否切圆角
        get { underLine.layer.cornerRadius > 0 }
        set {
            underLine.layer.cornerRadius = (newValue ? lineHeight / 2 : 0)
            underLine.layer.masksToBounds = newValue
        }
    }

    // 代理引用
    weak var dataSource: PageControllerDataSource?
    weak var delegate: PageControllerDelegate?

    // MARK: - 私有属性

    // UI参数
    // 下标
    private var lineHeight: CGFloat = 6 // 下标的默认高度
    private var lineSpacing: CGFloat = 5 // 下标和页眉间的间距
    private var lineDefaultTint: UIColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)

    // 页眉
    private var headerSpacing: CGFloat = 10 // 页眉之间的间距
    private var headerLRMargin: CGFloat = 20 // 页眉和容器左右两边的边距
    private var headerTopMargin: CGFloat = 0 // 页眉和容器上面的边距
    private var headerDefaultTint: UIColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    // 页眉容器
    private var headerContainerTint: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) // 页眉容器背景颜色
    private var headerContainerDefaultHeight: CGFloat = 40 // 页眉容器默认高度
    // 页面容器
    private var pageContainerTint: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // 页面容器默认颜色

    // 状态参数
    // 页眉
    private var titles: [String] // 页眉标题集合
    private lazy var headers: [PageHeader] = [] // 页眉集合
    private var selectedHeaderIndex: Int = -1 // 当前已选中的页眉的索引

    // 子View实例
    private lazy var headerContainer: UIScrollView = { // 页眉容器
        // frame设置
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        // 属性设置
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = headerContainerTint

        return scrollView
    }()

    private lazy var pageContainer: UIScrollView = { // 页面容器
        // frame设置
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        // 属性设置
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = pageContainerTint

        return scrollView
    }()

    private lazy var underLine: UIView = { // 页眉下标
        // frame设置
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false

        // 属性设置
        view.backgroundColor = lineDefaultTint

        return view
    }()

    // TODO: - 🆕 创建页面容器 和 页面 的类 和 相关属性

    // MARK: - 构造器

    // 指定构造器
    // 通过指定托管对象构造（需遵从相关协议）
    init(dataSource: PageControllerDataSource) {
        self.dataSource = dataSource
        titles = []
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildSubViews()
    }

    // 必要构造器
    // 从 xib 或者 storyboard中构造
    required init?(coder: NSCoder) {
        // FIXME: 只能手动输入storyboard name和所属ViewController的identify，待修复完善..
        let ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "woyuViewController")
        if let dataSource = ViewController as? PageControllerDataSource { self.dataSource = dataSource }

        titles = Array(repeating: "storyboard自动创建的页眉标题", count: 5)
        super.init(coder: coder)
        buildSubViews()
    }
}

// MARK: - 子view构建相关方法

// 页眉部分
extension PageController {
    // UI搭建
    private func buildSubViews() {
        createHeaderContainer()
        createPageContainer()
        createHeaders()
        createUnderLine()
    }

    // 创建页眉容器
    private func createHeaderContainer() {
        addSubview(headerContainer)

        // autolayout设置
        NSLayoutConstraint.activate([
            headerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerContainer.topAnchor.constraint(equalTo: topAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: headerContainerDefaultHeight),
        ])
    }

    // 创建页面容器
    private func createPageContainer() {
        addSubview(pageContainer)

        // autolayout设置
        NSLayoutConstraint.activate([
            pageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0),
            pageContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // 创建页眉
    private func createHeaders() {
        // 从代理函数中获取要创建的页眉/页面的数量
        guard let numOfPages = dataSource?.pageController(self, numberOfPagesInContainer: pageContainer) else { return }

        // 将从代理函数中获取的页眉进行必要相关设置后添加到容器中
        for index in 0 ..< numOfPages {
            guard let header = dataSource?.pageController(self, headerForPageAt: index) else { return }

            // 默认非选中状态
            header.isSelected = false

            // 设置页眉手势
            setupGesture(to: header)

            // 添加页眉进容器
            headerContainer.addSubview(header)

            // 设置页眉约束
            if let preHeader = headers.last {
                // 对其它页眉
                header.leadingAnchor.constraint(equalTo: preHeader.trailingAnchor, constant: headerSpacing, identifier: "headerLeading").isActive = true
            } else {
                // 对于第一个页眉
                header.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: headerLRMargin, identifier: "headerLeading").isActive = true
            }

            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: headerTopMargin, identifier: "headerTop"),
                header.widthAnchor.constraint(equalToConstant: header.textSize.width, identifier: "headerWidth"),
                header.heightAnchor.constraint(equalTo: headerContainer.heightAnchor, constant: -lineHeight - headerTopMargin - lineSpacing, identifier: "headerHeight"),
            ])

            // 添加页眉进集合
            headers.append(header)
        }

        // 对容器的contentSize进行约束
        if let lastHeader = headers.last {
            lastHeader.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -headerLRMargin).isActive = true
        }
    }

    // 创建页眉下标
    private func createUnderLine() {
        guard let firstPageHeader = headers.first else { return } // 获取第一个页眉
        updateHeadersFrame(firstPageHeader)

        // 切圆角
        underLine.layer.cornerRadius = lineHeight / 2
        underLine.layer.masksToBounds = true

        headerContainer.addSubview(underLine)

        // 设置autolayout参数
        NSLayoutConstraint.activate([
            underLine.topAnchor.constraint(equalTo: firstPageHeader.bottomAnchor, constant: lineSpacing, identifier: "lineTop"),
            underLine.centerXAnchor.constraint(equalTo: firstPageHeader.centerXAnchor, identifier: "lineCenterX\(firstPageHeader.index)"),
            underLine.widthAnchor.constraint(equalTo: firstPageHeader.widthAnchor, identifier: "lineWidth\(firstPageHeader.index)"),
            underLine.heightAnchor.constraint(equalToConstant: lineHeight, identifier: "lineHeight"),
        ])
    }
}

// MARK: - 交互相关方法

// 页眉交互
extension PageController {
    // 设置手势
    private func setupGesture(to target: PageHeader) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pageHeaderGestureResponder(_:)))
        tapGesture.numberOfTapsRequired = 1
        target.addGestureRecognizer(tapGesture)
        target.isUserInteractionEnabled = true
    }

    // 手势反馈
    @objc private func pageHeaderGestureResponder(_ sender: UITapGestureRecognizer) {
        guard let selectedHeader = sender.view as? PageHeader else { return }

        switchToTarget(selectedHeader)
    }
}

// MARK: - UI相关方法

// 页眉相关方法
extension PageController {
    // 切换页眉
    private func switchToTarget(_ header: PageHeader) {
        containerAdjust(forTarget: header)

        if header.index != selectedHeaderIndex {
            selectedTarget(header)
            resizeTarget(header)
            moveUnderLine(toTarget: header)
            selectedHeaderIndex = header.index // 更新当前已选中的页眉索引
            layoutIfNeeded()
        }
    }

    // 更新页眉的选中状态
    private func selectedTarget(_ header: PageHeader) {
        if selectedHeaderIndex >= 0 { headers[selectedHeaderIndex].isSelected = false }
        header.isSelected = true
    }

    // 根据选中后的页眉字体的变化重新调整页眉的大小
    private func resizeTarget(_ header: PageHeader) {
        if selectedHeaderIndex >= 0 { headers[selectedHeaderIndex].constraint(withIdentify: "headerWidth")?.constant = headers[selectedHeaderIndex].textSize.width }
        header.constraint(withIdentify: "headerWidth")?.constant = header.textSize.width
    }

    // 移动下标到所选中的页眉
    private func moveUnderLine(toTarget header: PageHeader) {
        if selectedHeaderIndex >= 0 {
            headerContainer.constraint(withIdentify: "lineCenterX\(selectedHeaderIndex)")?.isActive = false
            headerContainer.constraint(withIdentify: "lineWidth\(selectedHeaderIndex)")?.isActive = false

            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                NSLayoutConstraint.activate([
                    self.underLine.centerXAnchor.constraint(equalTo: header.centerXAnchor, identifier: "lineCenterX\(header.index)"),
                    self.underLine.widthAnchor.constraint(equalTo: header.widthAnchor, identifier: "lineWidth\(header.index)"),
                ])
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    // 将选中的页眉滑动到容器中央
    private func containerAdjust(forTarget header: PageHeader) {
        // 容器沿水平方向滑动的位移上限
        let upperLimit = headerContainer.contentSize.width - headerContainer.frame.size.width
        guard upperLimit > 0 else { return }

        // 让选中的页眉在容器中居中所需要的补正距离
        let offset = header.center.x - (headerContainer.frame.size.width / 2)

        switch offset {
        case ..<0:
            // 如果理论补正距离是负值就让容器复位
            headerContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

        case 0 ... upperLimit:
            // 如果理论补正距离在容器允许的位移范围内，就按照计算出来的补正距离进行补正
            headerContainer.setContentOffset(CGPoint(x: offset, y: 0), animated: true)

        default:
            // 如果补正距离超过了容器允许的位移范围上限，就将容器反向复位
            headerContainer.setContentOffset(CGPoint(x: upperLimit, y: 0), animated: true)
        }
    }
}

// MARK: - 其它方法

extension PageController {
    // 更新页眉的UI相关属性(用于构建UnderLine或者计算属性变更时)
    private func updateHeadersFrame(_ header: PageHeader) {
        selectedTarget(header)
        resizeTarget(header)
        selectedHeaderIndex = header.index // 更新当前已选中的页眉索引
    }
}
