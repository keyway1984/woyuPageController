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
    // MARK: - 公开属性

    // 代理引用
    weak var dataSource: PageControllerDataSource? // 数据源
    weak var layout: PageControllerDelegateLayout? // 布局

    // MARK: - 私有属性

    // 状态参数
    private lazy var headers: [PageHeader] = [] // 页眉集合
    private lazy var pages: [UIViewController] = [] // 页面集合
    private var selectedHeaderIndex: Int = -1 // 当前已选中的页眉的索引
    private var showUnderLine: Bool = true // 是否显示下标

    private var numberOfItems: Int = 0 // 页眉/页面的数量

    // 子View实例

    private lazy var headerContainer = PageContainer() // 页眉容器
    private lazy var pageTableContainer = PageContainer() // 页面容器
    private lazy var underLine = PageUnderLine() // 页眉下标

    // MARK: - 构造器

    // 指定构造器
    // 通过指定托管对象构造（需遵从相关协议）
    init(viewController: UIViewController) {
        if let dataSource = viewController as? PageControllerDataSource { self.dataSource = dataSource }
        if let layout = viewController as? PageControllerDelegateLayout { self.layout = layout }
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

        super.init(coder: coder)
        buildSubViews()
    }
}

// MARK: - 子view构建相关方法

// 页眉部分
extension PageController {
    // UI搭建
    private func buildSubViews() {
        updateProperty()
        createHeaderContainer()
        createPageContainer()
        createHeaders()
        createUnderLine()
        createPageTables()
    }

    // 根据代理函数的返回值更新相关属性
    private func updateProperty() {
        // 更新页眉容器高度
        if let height = layout?.pageController(self, heightOfHeaderContainer: headerContainer) { headerContainer.height = height }

        // 更新页眉/页面数量
        if let nums = dataSource?.pageController(self, numberOfPagesInContainer: pageTableContainer) { numberOfItems = nums }

        // 更新下标属性
        if let state = layout?.pageController(self, showUnderLineForSelectedHeader: &underLine) { showUnderLine = state }
    }

    // 创建页眉容器
    private func createHeaderContainer() {
        addSubview(headerContainer)

        // autolayout设置
        NSLayoutConstraint.activate([
            headerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerContainer.topAnchor.constraint(equalTo: topAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: headerContainer.height),
        ])
    }

    // 创建页面容器
    private func createPageContainer() {
        addSubview(pageTableContainer)

        // 属性设置
        pageTableContainer.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        pageTableContainer.isPagingEnabled = true

        // 设置代理
        pageTableContainer.delegate = self

        // autolayout设置
        NSLayoutConstraint.activate([
            pageTableContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageTableContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageTableContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0),
            pageTableContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // 创建页眉
    private func createHeaders() {
        // 将从代理函数中获取的页眉进行必要相关设置后添加到容器中
        for index in 0 ..< numberOfItems {
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
                header.leadingAnchor.constraint(equalTo: preHeader.trailingAnchor, constant: header.spacing, identifier: "headerLeading\(index)").isActive = true
            } else {
                // 对于第一个页眉
                header.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: header.LRMargin, identifier: "headerLeading\(index)").isActive = true
            }

            // 根据代理函数指示是否显示页眉下标而计算出不同的页眉高度约束
            let heightConstant: CGFloat = showUnderLine ? -underLine.height - header.topMargin - underLine.spacing : -header.topMargin - header.bottomMargin

            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: header.topMargin, identifier: "headerTop\(index)"),
                header.widthAnchor.constraint(equalToConstant: header.textSize.width, identifier: "headerWidth\(index)"),
                header.heightAnchor.constraint(equalTo: headerContainer.heightAnchor, constant: heightConstant, identifier: "headerHeight\(index)"),
            ])

            // 添加页眉进集合
            headers.append(header)
        }

        // 对容器的contentSize进行约束
        if let lastHeader = headers.last {
            lastHeader.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -lastHeader.LRMargin).isActive = true
        }
    }

    // 创建页面
    private func createPageTables() {
        for index in 0 ..< numberOfItems {
            // 从代理函数获取ViewController
            guard let page = dataSource?.pageController(self, pageForHeaderAt: index) else { return }

            // 添加页面进容器
            pageTableContainer.addSubview(page.view)

            // 设置页面约束
            if let prePage = pages.last {
                // 对于其它页面
                page.view.leadingAnchor.constraint(equalTo: prePage.view.trailingAnchor, identifier: "pageLeading\(index)").isActive = true
            } else {
                // 对于第一个页面
                page.view.leadingAnchor.constraint(equalTo: pageTableContainer.leadingAnchor, identifier: "pageLeading\(index)").isActive = true
            }
            // 设置其它约束
            NSLayoutConstraint.activate([
                page.view.topAnchor.constraint(equalTo: pageTableContainer.topAnchor, identifier: "pageTop\(index)"),
                page.view.widthAnchor.constraint(equalTo: pageTableContainer.widthAnchor, identifier: "pageWidth\(index)"),
                page.view.heightAnchor.constraint(equalTo: pageTableContainer.heightAnchor, identifier: "pageHeight\(index)"),
            ])

            // 添加页面进集合
            pages.append(page)
        }

        // 对容器的contentSize进行约束
        if let lastPage = pages.last {
            lastPage.view.trailingAnchor.constraint(equalTo: pageTableContainer.trailingAnchor).isActive = true
        }
    }

    // 创建页眉下标
    private func createUnderLine() {
        // 从页眉集合中获取第一个页眉
        guard let firstPageHeader = headers.first else { return }
        updateHeadersFrame(firstPageHeader)

        // 如果代理函数指示不显示下标，则返回
        guard showUnderLine else { return }

        // 将下标加入页眉容器
        headerContainer.addSubview(underLine)

        // 设置autolayout参数
        NSLayoutConstraint.activate([
            underLine.topAnchor.constraint(equalTo: firstPageHeader.bottomAnchor, constant: underLine.spacing, identifier: "lineTop"),
            underLine.heightAnchor.constraint(equalToConstant: underLine.height, identifier: "lineHeight"),
            underLine.leadingAnchor.constraint(equalTo: firstPageHeader.leadingAnchor, identifier: "lineLeading\(firstPageHeader.index)"),
            underLine.trailingAnchor.constraint(equalTo: firstPageHeader.trailingAnchor, identifier: "lineTrailing\(firstPageHeader.index)"),
        ])
    }
}

// MARK: - 交互相关方法

// 页眉交互
extension PageController {
    // 页眉
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

        switchToHeader(selectedHeader)
        moveUnderLine(whenClickedHeader: selectedHeader)
        containerAdjust(whenClickedHeader: selectedHeader)
        turnToPage(pages[selectedHeader.index])

        selectedHeaderIndex = selectedHeader.index // 更新当前已选中的页眉索引
    }
}

// 页面交互
extension PageController: UIScrollViewDelegate {
    // 监听页面的滑动位移
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 确保监听的对象容器是页面容器而非页眉容器
        if scrollView == pageTableContainer, scrollView.isTracking { // 确保以下代码仅在用户触摸屏幕时才触发
            let offsetScale = pageTableContainer.contentOffset.x / pageTableContainer.frame.size.width // 获取容器contentView的滑动系数
            let targetIndex = Int(roundf(Float(offsetScale))) // 将滑动系数四舍五入后获取要切换的目标页眉索引

            switchToHeader(headers[targetIndex]) // 根据目标页眉索引进行页眉切换
            moveUnderLine(whenDraggingPage: offsetScale)
            containerAdjust(whenDraggingPage: offsetScale) // 如果不需要做到像斗鱼APP那样在划页的同时移动页眉容器，则这个方法可以去掉
            selectedHeaderIndex = targetIndex // 更新当前已选中的页眉索引
        }
    }

    // 监听翻页动作目标页面索引
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 确保监听的对象容器是页面容器而非页眉容器
        if scrollView == pageTableContainer {
            let targetIndex = Int(targetContentOffset.pointee.x / pageTableContainer.frame.size.width) // 获取当前页面索引

            switchToHeader(headers[targetIndex]) // 根据目标页眉索引进行页眉切换
            moveUnderLine(whenClickedHeader: headers[targetIndex])
            containerAdjust(whenClickedHeader: headers[targetIndex]) // 根据当前页面索引进行对应页眉的容器居中校正

            selectedHeaderIndex = targetIndex // 更新当前已选中的页眉索引
        }
    }
}

// MARK: - UI相关方法

// 页面相关方法
extension PageController {
    // 切换页面
    private func turnToPage(_ page: UIViewController) {
        pageTableContainer.setContentOffset(page.view.frame.origin, animated: false)
    }
}

// 页眉相关方法
extension PageController {
    // 切换页眉
    private func switchToHeader(_ header: PageHeader) {
        if header.index != selectedHeaderIndex {
            selectedTarget(header)
            resizeTarget(header)
            layoutIfNeeded()
        }
    }

    // 更新页眉的选中状态
    private func selectedTarget(_ header: PageHeader) {
        if selectedHeaderIndex >= 0 {
            headers[selectedHeaderIndex].isSelected = false
        }
        header.isSelected = true
    }

    // 根据选中后的页眉字体的变化重新调整页眉的大小
    private func resizeTarget(_ header: PageHeader) {
        if selectedHeaderIndex >= 0 {
            headers[selectedHeaderIndex].constraint(withIdentify: "headerWidth\(selectedHeaderIndex)")?.constant = headers[selectedHeaderIndex].textSize.width
        }
        header.constraint(withIdentify: "headerWidth\(header.index)")?.constant = header.textSize.width
    }
}

// 页眉容器相关方法
extension PageController {
    // 将选中的页眉滑动到容器中央
    // 点击页眉触发
    private func containerAdjust(whenClickedHeader header: PageHeader) {
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

    // 滑动页面触发
    private func containerAdjust(whenDraggingPage offsetScale: CGFloat) {
        // 确保数组不要越界
        guard offsetScale > 0, offsetScale < CGFloat(numberOfItems) - 1 else { return }
        // 容器沿水平方向滑动的位移上限
        let upperLimit = headerContainer.contentSize.width - headerContainer.frame.size.width
        guard upperLimit > 0 else { return }

        // 获取页面的滑动方向
        let direction = pageTableContainer.panGestureRecognizer.translation(in: self).x > 0

        var currentIndex: Int = 0 // 当前页眉索引
        var targetIndex: Int = 0 // 滑动目标页眉索引
        var percent: CGFloat = 0 // 翻页百分比
        let ceilIndex = Int(ceil(Double(offsetScale))) // 位移比例的向上取整数
        let floorIndex = Int(floor(Double(offsetScale))) // 位移比例的向下取整数

        // 根据滑动方向不同，各个参数的赋值也不同
        if direction {
            // 朝左滑动
            currentIndex = ceilIndex
            targetIndex = floorIndex
            percent = CGFloat(ceilIndex) - offsetScale
        } else {
            // 朝右滑动
            currentIndex = floorIndex
            targetIndex = ceilIndex
            percent = offsetScale - CGFloat(floorIndex)
        }

        // 获取当前页眉和滑动目标页眉之间的距离
        let constant = headers[targetIndex].center.x - headers[currentIndex].center.x
        // 获取当前容器已经位移的数量
        let contentOffset = headers[currentIndex].center.x - (headerContainer.frame.size.width / 2)
        // 计算出需要补正的距离
        let offset = contentOffset + constant * percent

        switch offset {
        case ..<0:
            // 如果理论补正距离是负值就让容器复位
            headerContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: false)

        case 0 ... upperLimit:
            // 如果理论补正距离在容器允许的位移范围内，就按照计算出来的补正距离进行补正
            headerContainer.setContentOffset(CGPoint(x: offset, y: 0), animated: false)

        default:
            // 如果补正距离超过了容器允许的位移范围上限，就将容器反向复位
            headerContainer.setContentOffset(CGPoint(x: upperLimit, y: 0), animated: false)
        }
    }
}

// 下标相关方法
extension PageController {
    // 移动下标到所选中的页眉
    // 点击页眉触发
    private func moveUnderLine(whenClickedHeader header: PageHeader) {
        // 从代理函数中获取页眉下标是否显示的指示
        guard showUnderLine, !headers.isEmpty else { return }

        if selectedHeaderIndex >= 0 {
            // 目标页眉到第一个页眉leading constant的值
            let leadingConstant = header.frame.origin.x - headers[0].frame.origin.x
            // 目标页眉到第一个页眉trailing constant的值
            let trailingConstant = (header.frame.origin.x - headers[0].frame.origin.x) + (header.frame.size.width - headers[0].frame.size.width)

            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.headerContainer.constraint(withIdentify: "lineLeading\(0)")?.constant = leadingConstant
                self.headerContainer.constraint(withIdentify: "lineTrailing\(0)")?.constant = trailingConstant
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    // 滑动页面触发
    private func moveUnderLine(whenDraggingPage offsetScale: CGFloat) {
        // 从代理函数中获取页眉下标是否显示的指示，同时确保数组不要越界
        guard showUnderLine, offsetScale > 0, offsetScale < CGFloat(numberOfItems) - 1, !headers.isEmpty else { return }

        // 获取页面的滑动方向
        let direction = pageTableContainer.panGestureRecognizer.translation(in: self).x > 0

        var currentIndex: Int = 0 // 当前页眉索引
        var targetIndex: Int = 0 // 滑动目标页眉索引
        var percent: CGFloat = 0 // 翻页百分比
        let ceilIndex = Int(ceil(Double(offsetScale))) // 位移比例的向上取整数
        let floorIndex = Int(floor(Double(offsetScale))) // 位移比例的向下取整数

        if direction {
            // 朝左滑动
            currentIndex = ceilIndex
            targetIndex = floorIndex
            percent = CGFloat(ceilIndex) - offsetScale
        } else {
            // 朝右滑动
            currentIndex = floorIndex
            targetIndex = ceilIndex
            percent = offsetScale - CGFloat(floorIndex)
        }

        // 获取当前下标约束的leading
        let leading = headers[currentIndex].frame.origin.x - headers[0].frame.origin.x
        // 获取移动到目标页眉leading需要增加的值
        let leadingConstant = headers[targetIndex].frame.origin.x - headers[currentIndex].frame.origin.x

        let trailing = headers[currentIndex].frame.origin.x - headers[0].frame.origin.x + (headers[currentIndex].frame.size.width - headers[0].frame.size.width)
        let trailingConstant = headers[targetIndex].frame.origin.x - headers[currentIndex].frame.origin.x + (headers[targetIndex].frame.size.width - headers[currentIndex].frame.size.width)

        // 根据划页动作实时更新下标约束值
        headerContainer.constraint(withIdentify: "lineLeading\(0)")?.constant = leading + leadingConstant * percent
        headerContainer.constraint(withIdentify: "lineTrailing\(0)")?.constant = trailing + trailingConstant * percent
        layoutIfNeeded()
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
