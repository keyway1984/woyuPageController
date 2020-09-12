//
//  ExtensionMethods.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/12.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import Foundation
import UIKit

//对原生类的拓展使用方法


//MARK: - NSLayoutConstraint Extension Methods
extension NSLayoutAnchor {
    
    //给view设定约束的同时赋予识别符
    @objc func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat, identifier: String) -> NSLayoutConstraint {
        
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.identifier = identifier
        return constraint
    }
}


//MARK: - NSLayoutDimension Extension Methods
extension NSLayoutDimension {
    
    //给view设定约束的同时赋予识别符
    @objc func constraint(equalToConstant constant: CGFloat, identifier: String) -> NSLayoutConstraint {
        
        let constraint = self.constraint(equalToConstant: constant)
        constraint.identifier = identifier
        return constraint
    }
}


//MARK: - UIView Extension Methods
extension UIView {
    
    //查找特定识别符的约束
    func constraint(withIdentify: String) -> NSLayoutConstraint? {
        return self.constraints.filter{ $0.identifier == withIdentify}.first
    }
}
