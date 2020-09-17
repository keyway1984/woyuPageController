//
//  PageTable.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/16.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import UIKit

class PageTable: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 属性设置
        view.frame = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.random()
    }
}

// MARK: - 相关方法

extension PageTable {
    func buildLabel(title: String) {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.sizeToFit()

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
