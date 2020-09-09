//
//  ViewController.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/7.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var pageController: PageController!
    

    
//    private lazy var pageHeader: PageController = {
//
//        let titles = ["标题111111111","标题23333","标题3","标题4","标题5","标题6","标题7","标题8","标题9","标题10","标题11","标题12"]
//        let pagecontroller = PageController(pageHeaderTitles: titles)
//        pagecontroller.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
//        return pagecontroller
//    }()
//
    
        private lazy var pageHeader: PageController = {

            let pagecontroller = PageController(delegate: self)
            pagecontroller.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            return pagecontroller
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.isHidden = true
        
//        pageController.dataSource = self


        self.view.addSubview(pageHeader)


        NSLayoutConstraint.activate([

            pageHeader.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            pageHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            pageHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            pageHeader.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}


extension ViewController: PageHeaderControllerDataSource {
    func setPageHeaderTitles() -> [String] {
        return ["111111111111111","222222","33333","444444","5555555"]
    }
    
    
}


    
 
    

