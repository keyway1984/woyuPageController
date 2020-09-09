//
//  PageHeader.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/8.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit

//MARK: - 相关协议
protocol PageHeaderDelegate {
    func PageHeaderIsClicked(_ pageHeader: PageHeader, index: Int)
}


//MARK: - PageHeader 类定义
class PageHeader: UIView {
    
    //MARK: - 公有属性
    var textWidth: CGFloat = 0  //页眉标题宽度
    
    
    //MARK: - 私有属性
    private let text: String    //页眉标题
    private let index: Int  //页眉索引
    
    //MARK: - 代理引用
    var delegate: PageHeaderDelegate?
    
    
    private lazy var button: UIButton = {   //页眉按钮
        
        //frame设置
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        //属性设置
        button.isUserInteractionEnabled = true
        button.setTitle(text, for: .normal)
        button.tag = index
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        
        //手势设置
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        //记录文本宽度
        button.sizeToFit()
        self.textWidth = button.frame.width
        
        return button
    }()
    

    //MARK: - 构造器
    
    //指定构造器
    init(_ index: Int, _ title: String) {
        self.index = index
        self.text = title
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        commonInit()
    }
    
    //从xib 或者 storyboard 构造
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //自定义初始化内容
    private func commonInit() {
        self.isUserInteractionEnabled = true
        buildSubViews()
    }
    
}


//MARK: - 添加子view
extension PageHeader {
    //添加子view
    private func buildSubViews() {

        self.addSubview(button)

        //autolayout设置
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}


//MARK: - 添加手势
extension PageHeader {
    
    @objc func buttonAction(sender: UIButton!) {
        
        self.delegate?.PageHeaderIsClicked(self, index: self.index)
    }
}
