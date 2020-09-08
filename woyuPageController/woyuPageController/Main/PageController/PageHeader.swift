//
//  PageHeader.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/8.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit

class PageHeader: UIView {
    
    //MARK: - 公有属性
    private let text: String    //页眉标题
    private let index: Int  //页眉索引
    
    
    //MARK: - 私有属性
    private lazy var button: UIButton = {   //页眉按钮
        
        let button = UIButton()
        
        button.titleLabel?.text = text
        button.tag = index
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 0

        button.titleLabel?.textAlignment = .center
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return button
    }()
    

    //MARK: - 构造器
    
    //指定构造器
    init(index: Int, title: String) {
        self.index = index
        self.text = title
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.translatesAutoresizingMaskIntoConstraints = false
        commonInit()
    }
    
    //从xib 或者 storyboard 构造
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //自定义初始化内容
    private func commonInit() {
        buildSubViews()
    }
    
}


//MARK: - 添加子view
extension PageHeader {
    //添加子view
    private func buildSubViews() {
        
        self.addSubview(button)
        button.frame = self.bounds
//        NSLayoutConstraint.activate([
//
//            button.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
//            button.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
//        ])
    }
}
