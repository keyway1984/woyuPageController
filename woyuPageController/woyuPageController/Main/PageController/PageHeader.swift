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
    var textSize: CGSize = .zero  //页眉标题宽度
    
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
        label.font = UIFont.boldSystemFont(ofSize: 13)
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
        createButton()
    }
    
    //创建按钮
    private func createButton() {
        
        self.addSubview(headerBody)
        
        //autolayout设置
        NSLayoutConstraint.activate([
            headerBody.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0, identifier: "bottom"),
            headerBody.widthAnchor.constraint(equalToConstant: textSize.width, identifier: "width"),
            headerBody.heightAnchor.constraint(equalToConstant: textSize.height, identifier: "height")
        ])
    }
}

//MARK: - UI相关方法
extension PageHeader {
    
    //管理页眉的点选状态
    private func selectionStateManger(_ body: UILabel) {

        if selectedState {

            body.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            bodyAnimation(body)

        } else {

            body.textColor = #colorLiteral(red: 0.003166038077, green: 0.003167069284, blue: 0.003165812464, alpha: 1)
            body.transform = CGAffineTransform(scaleX: 1, y: 1)
        }

        //更新当前文本宽度
        body.sizeToFit()
        self.textSize = body.frame.size
            
        //更新body的约束
        body.constraint(withIdentify: "width")?.constant = textSize.width
        body.constraint(withIdentify: "height")?.constant = textSize.height
    }

    
    //设置页眉标题字体缩放的动画效果
    private func bodyAnimation(_ body: UILabel) {

        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {

            body.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

        }, completion: nil)
        
    }
}




