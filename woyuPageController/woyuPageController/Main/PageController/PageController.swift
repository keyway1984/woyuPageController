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
protocol PageHeaderControllerDataSource: AnyObject {
    // 获取页眉标题字符串组
    func SetPageHeaderTitlesTo(_ pageController: PageController, pageHeaders: [PageHeader]) -> [String]
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
                headersContainer.constraints.forEach { // 注意子view引用其它view实现的约束在运行时都会算作父view的约束
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

    // 页眉
    var headerTint: UIColor? { // 设置页眉背景颜色
        get { headers.first?.backgroundColor }
        set { headers.forEach { $0.backgroundColor = newValue } }
    }

    var titleFont: UIFont? { // 设置页眉非点选状态字体
        get { headers.first?.textFont }
        set {
            if let newFont = newValue {
                headers.reversed().forEach {
                    $0.textFont = newFont
                    self.updateHeadersFrame($0)
                }
            }
        }
    }

    var titleTint: UIColor? { // 设置页眉非点选状态字体颜色
        get { headers.first?.textTint }
        set {
            if let newTint = newValue {
                headers.reversed().forEach {
                    $0.textTint = newTint
                    self.updateHeadersFrame($0)
                }
            }
        }
    }

    var titleFontHL: UIFont? { // 设置页眉点选状态字体
        get { headers.first?.textFontHL }
        set {
            if let newFont = newValue {
                headers.reversed().forEach {
                    $0.textFontHL = newFont
                    self.updateHeadersFrame($0)
                }
            }
        }
    }

    var titleTintHL: UIColor? { // 设置页眉点选状态字体颜色
        get { self.headers.first?.textTintHL }
        set {
            if let newTint = newValue {
                self.headers.reversed().forEach {
                    $0.textTintHL = newTint
                    self.updateHeadersFrame($0)
                }
            }
        }
    }

    // 代理引用
    weak var dataSource: PageHeaderControllerDataSource?
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
    // 容器
    private var containerTint: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) // 容器背景颜色

    // 状态参数
    // 页眉
    private var titles: [String] // 页眉标题集合
    private lazy var headers: [PageHeader] = [] // 页眉集合
    private var selectedHeaderIndex: Int = -1 // 当前已选中的页眉的索引

    // 子View实例
    private lazy var headersContainer: UIScrollView = { // 页眉容器
        // frame设置
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        // 属性设置
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = containerTint

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
    // 通过指定页眉标题构造
    init(pageHeaderTitles: [String]) {
        titles = pageHeaderTitles
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildSubViews()
    }

    // 通过指定托管对象构造（需遵从相关协议）
    init(dataSource: PageHeaderControllerDataSource) {
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
        if let dataSource = ViewController as? PageHeaderControllerDataSource { self.dataSource = dataSource }

        titles = Array(repeating: "storyboard自动创建的页眉标题", count: 5)
        super.init(coder: coder)
        buildSubViews()
    }

    // 便利构造器
    // 自动创建复数个相同的标题
    convenience init() {
        let titles: [String] = Array(repeating: "自动创建的页眉标题", count: 5)
        self.init(pageHeaderTitles: titles)
    }
}

// MARK: - 子view构建相关方法

extension PageController {
    // UI搭建
    private func buildSubViews() {
        createPageHeaderContainer()
        createPageHeaders()
        createUnderLine()
    }

    // 创建页眉容器
    private func createPageHeaderContainer() {
        addSubview(headersContainer)

        // autolayout设置
        // TODO: - 🆕 因为加入了页面容器和页眉，之前的约束要修改
        NSLayoutConstraint.activate([
            headersContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            headersContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            headersContainer.topAnchor.constraint(equalTo: topAnchor),
            headersContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // 创建页眉
    private func createPageHeaders() {
        // 从代理函数中获取页眉标题数据源
        if let titles = dataSource?.SetPageHeaderTitlesTo(self, pageHeaders: headers) { self.titles = titles }

        // 根据标题初始化页眉
        for (index, title) in titles.enumerated() {
            // 创建页眉
            let pageHeader = PageHeader(index, title)

            // 设置页眉属性
            pageHeader.backgroundColor = headerDefaultTint

            // 设置页眉手势
            setupGesture(to: pageHeader)

            // 添加页眉进容器
            headersContainer.addSubview(pageHeader)

            // 设置页眉约束
            if let prePageHeader = headers.last {
                // 对其它页眉
                pageHeader.leadingAnchor.constraint(equalTo: prePageHeader.trailingAnchor, constant: headerSpacing, identifier: "headerLeading").isActive = true
            } else {
                // 对于第一个页眉
                pageHeader.leadingAnchor.constraint(equalTo: headersContainer.leadingAnchor, constant: headerLRMargin, identifier: "headerLeading").isActive = true
            }

            // TODO: - 🆕 因为加入了页面容器和页眉，之前的约束要修改
            NSLayoutConstraint.activate([
                pageHeader.topAnchor.constraint(equalTo: headersContainer.topAnchor, constant: headerTopMargin, identifier: "headerTop"),
                pageHeader.widthAnchor.constraint(equalToConstant: pageHeader.textSize.width, identifier: "headerWidth"),
                pageHeader.heightAnchor.constraint(equalTo: headersContainer.heightAnchor, constant: -lineHeight - headerTopMargin - lineSpacing, identifier: "headerHeight"),
            ])

            // 添加页眉进集合
            headers.append(pageHeader)
        }

        // 对容器的contentSize进行约束
        if let lastPageHeader = headers.last {
            lastPageHeader.trailingAnchor.constraint(equalTo: headersContainer.trailingAnchor, constant: -headerLRMargin).isActive = true
        }
    }

    // 创建页眉下标
    private func createUnderLine() {
        guard let firstPageHeader = headers.first else { return } // 获取第一个页眉
        updateHeadersFrame(firstPageHeader)

        // 切圆角
        underLine.layer.cornerRadius = lineHeight / 2
        underLine.layer.masksToBounds = true

        headersContainer.addSubview(underLine)

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
            headersContainer.constraint(withIdentify: "lineCenterX\(selectedHeaderIndex)")?.isActive = false
            headersContainer.constraint(withIdentify: "lineWidth\(selectedHeaderIndex)")?.isActive = false

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
        // 让选中的页眉在容器中居中所需要的补正距离
        let offset = header.center.x - (headersContainer.frame.size.width / 2)

        // 容器沿水平方向滑动的位移上限
        let upperLimit = headersContainer.contentSize.width - headersContainer.frame.size.width

        switch offset {
        case ..<0:
            // 如果理论补正距离是负值就让容器复位
            headersContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

        case 0 ... upperLimit:
            // 如果理论补正距离在容器允许的位移范围内，就按照计算出来的补正距离进行补正
            headersContainer.setContentOffset(CGPoint(x: offset, y: 0), animated: true)

        default:
            // 如果补正距离超过了容器允许的位移范围上限，就将容器反向复位
            headersContainer.setContentOffset(CGPoint(x: upperLimit, y: 0), animated: true)
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
