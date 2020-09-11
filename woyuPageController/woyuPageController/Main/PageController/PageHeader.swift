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
    var textWidth: CGFloat = 0  //页眉标题宽度
    
    //状态参数
    let text: String    //页眉标题
    let index: Int  //页眉索引
    var isSelected: Bool {  //反馈页眉的选中状态
        get { return selectedState }
        
        set(newState) {
            selectedState = newState
            
            if newState { selectedState(label) } else { deselectedState(label) }
        }
    }
    
    
    //MARK: - 私有属性
    //状态参数
    private var selectedState: Bool = false //记录页眉的选中状态
    
    //子view实例
    private lazy var label: UILabel = {   //页眉主体
        
        //frame设置
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        //属性设置
        label.text = self.text
        label.tag = index
        label.numberOfLines = 0
        label.textAlignment = .center
        self.deselectedState(label)
        
        //记录文本宽度
        label.sizeToFit()
        self.textWidth = label.frame.width
        
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
        createButton()
    }
    
    //创建按钮
    private func createButton() {
        
        self.addSubview(label)
        
        //autolayout设置
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

//MARK: - UI相关方法
extension PageHeader {
    
    //设置页眉主体的点选状态
    private func selectedState(_ label: UILabel) {
        
        label.textColor = #colorLiteral(red: 0.9909599423, green: 0.2717903256, blue: 0.1500301957, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    }
    
    //设置页眉主体的非选中状态
    private func deselectedState(_ label: UILabel) {
        
        label.textColor = #colorLiteral(red: 0.003166038077, green: 0.003167069284, blue: 0.003165812464, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    }
}




