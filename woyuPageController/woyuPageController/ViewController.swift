//
//  ViewController.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/7.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var pageHeader: PageController = {
       
        let frame = CGRect(x: 0, y: 164, width: UIScreen.main.bounds.width, height: 60)
        let titles = ["标题1","标题2","标题3","标题4","标题5","标题6","标题7","标题8","标题9","标题10","标题11","标题12"]
        let pagecontroller = PageController(frame: frame, pageHeaderTitles: titles)
        pagecontroller.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return pagecontroller
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pageHeader)
    }


}

