//
//  ViewController.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/7.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit


//MARK: - ViewController
class ViewController: UIViewController {
    
    
    //MARK: - 实例
    //页眉控制器
    private lazy var pageHeader: PageController = {
        
        //几种构造方式
        //1.指定页眉标题
        let titles = ["指定创建的标题1","指定创建的标题2","指定创建的标题3","指定创建的标题4","指定创建的标题5"]
        let pagecontroller = PageController(pageHeaderTitles: titles)
        
        //2.通过当前vc指定为数据源获取对象构造（需要额外完成协议函数）
//        let pagecontroller = PageController(dataSource: self)
        
        //3.通过便利构造器构造（自动生成一系列相同的标题）
//        let pagecontroller = PageController()
        
        pagecontroller.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return pagecontroller
    }()
    
    //4.通过storyboard创建
    @IBOutlet weak var pageController: PageController!

    
    override func viewDidLoad() {
        super.viewDidLoad()


//        pageController.dataSource = self
//        pageController.isHidden = true
//
//        self.view.addSubview(pageHeader)
//
//        //为页眉管理器指定约束
//        NSLayoutConstraint.activate([
//            pageHeader.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
//            pageHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//            pageHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
//            pageHeader.heightAnchor.constraint(equalToConstant: 80)
//        ])
    }
}


//MARK: - PageHeaderControllerDataSource Methods
extension ViewController: PageHeaderControllerDataSource {
    
    //指定页眉标题数据源
    func SetPageHeaderTitlesTo(_ pageController: PageController, pageHeaders: [PageHeader]) -> [String] {
        
        var titles: [String] = []
        
        for index in 0...8 {
            titles.append("代理创建的标题\(index)")
        }
        
        return titles
    }
}






