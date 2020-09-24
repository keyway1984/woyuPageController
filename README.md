# woyuPageController

![](https://img.shields.io/badge/language-swift-orange.svg)


## 内容列表

- [背景](#背景)
- [安装](#安装)
- [使用说明](#使用说明)
- [示例](#示例)
- [使用许可](#使用许可)

## 背景

`woyuPageController` 是对ios开发中最常见的一种业务逻辑（页眉管理器）的学习结果。


## 安装

截止到目前为止，还没进行相关封装。你可以将整个项目下载下来在xcode中查看。


## 使用说明

你可以通过满足以下协议来对PageController进行定制。

```swift
// 数据源
protocol PageControllerDataSource: class {
    // 指定页眉/页面数量
    func pageController(_ controller: PageController, numberOfPagesInContainer: PageContainer) -> Int

    // 获取初始化创建的页眉
    func pageController(_ controller: PageController, headerForPageAt index: Int) -> PageHeader
    
    //获取初始化创建的页面
    func pageController(_ controller: PageController, pageForHeaderAt index: Int) -> UIViewController
}

// UI布局
protocol PageControllerDelegateLayout: class {
    // 指定页眉容器高度
    func pageController(_: PageController, heightOfHeaderContainer container: PageContainer) -> CGFloat
    // 设置页眉下标是否显示/定制页眉下标
    func pageController(_ controller: PageController, showUnderLineForSelectedHeader line: inout PageUnderLine) -> Bool
    // 设置页眉右侧barItem是否显示/定制barItem
    func pageController(_ controller: PageController, showRightBarItem item: inout PageRightBarItem) -> Bool
}
```


## 示例

图片中以斗鱼app的样式进行定制。
> 斗鱼app的样式包括：隐藏下标，页眉标题在点击状态有文本放大动画，在滑动页面的同时页眉容器也会相应移动，包含rightBarItem等。


![image](https://github.com/keyway1984/woyuPageController/blob/master/IMG/ezgif-6-b7663d058344.gif)


## 使用许可

[MIT](LICENSE) © 魏卧鱼
