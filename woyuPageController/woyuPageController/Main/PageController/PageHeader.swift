//
//  PageHeader.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/8.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit



//MARK: - PageHeader 类定义
class PageHeader: UIView {
    
    
    //MARK: - 公有属性
    //UI参数
    var textSize: CGSize = .zero  //页眉标题尺寸
    var textFont: UIFont = UIFont.boldSystemFont(ofSize: 13)    //页眉标题字体（非选中状态）
    var textFontHL: UIFont = UIFont.boldSystemFont(ofSize: 18)  //页眉标题字体（选中状态）
    var textTintColor: UIColor = #colorLiteral(red: 0.003166038077, green: 0.003167069284, blue: 0.003165812464, alpha: 1)  //页眉字体颜色（非选中状态）
    var textTintColorHL: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)   //页眉字体颜色（选中状态）
    
    
    //状态参数
    let text: String    //页眉标题
    let index: Int  //页眉索引
    var isSelected: Bool {  //反馈页眉的选中状态
        
        get { return selectedState }
        
        set(newState) {
            selectedState = newState
            selectionStateManger(headerBody)
        }
    }
    var useAnimation: Bool = true   //缩放动画开关
    
    
    
    //MARK: - 私有属性
    //状态参数
    private var selectedState: Bool = false //记录页眉的选中状态
    
    //子view实例
    private lazy var headerBody: UILabel = {   //页眉主体
        
        //frame设置
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        //属性设置
        label.text = self.text
        label.tag = index
        label.numberOfLines = 1
        label.textAlignment = .center
        selectionStateManger(label)
        
        return label
    }()
    
    
    //MARK: - 构造器
    //指定构造器
    //通过指定页眉索引和标题字符串构造
    init(_ index: Int, _ title: String) {
        self.index = index
        self.text = title
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        buildSubViews()
    }
    
    //必要构造器
    //当前类不支持从xib 或者 storyboard 构造
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - 子view构建相关方法
extension PageHeader {
    
    //UI搭建
    private func buildSubViews() {
        createHeaderBody()
    }
    
    //创建按钮
    private func createHeaderBody() {
        
        self.addSubview(headerBody)
        
        //autolayout设置
        NSLayoutConstraint.activate([
            headerBody.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0, identifier: "bottom"),
            headerBody.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0, identifier: "leading"),
            headerBody.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0, identifier: "trailing")
        ])
    }
}

//MARK: - UI相关方法
extension PageHeader {
    
    //管理页眉的点选状态
    private func selectionStateManger(_ body: UILabel) {

        if selectedState {

            body.textColor = textTintColorHL
            if useAnimation { body.fontsizeAnimat(textFontHL, withDuration: 0.1) } else { body.font = textFontHL }

        } else {

            body.textColor = textTintColor
            body.font = textFont
        }

        //更新当前文本尺寸
        body.sizeToFit()
        self.textSize = body.frame.size
    }
}




