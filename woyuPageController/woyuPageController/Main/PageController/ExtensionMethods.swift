//
//  ExtensionMethods.swift
//  woyuPageController
//
//  Created by 魏卧鱼 on 2020/9/12.
//  Copyright © 2020 魏卧鱼. All rights reserved.
//

import Foundation
import UIKit

// 对原生类的拓展使用方法

// MARK: - NSLayoutConstraint

extension NSLayoutAnchor {
    // 给view设定约束的同时赋予识别符
    @objc func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.identifier = identifier
        return constraint
    }

    @objc func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor)
        constraint.identifier = identifier
        return constraint
    }
}

// MARK: - NSLayoutDimension

extension NSLayoutDimension {
    // 给view设定约束的同时赋予识别符
    @objc func constraint(equalToConstant constant: CGFloat, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalToConstant: constant)
        constraint.identifier = identifier
        return constraint
    }

    @objc func constraint(equalTo dimension: NSLayoutDimension, multiplier: CGFloat, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: dimension, multiplier: multiplier)
        constraint.identifier = identifier
        return constraint
    }
}

// MARK: - UIView

extension UIView {
    // 查找特定识别符的约束
    func constraint(withIdentify: String) -> NSLayoutConstraint? {
        constraints.filter { $0.identifier == withIdentify }.first
    }
}

// MARK: - UILabel

extension UILabel {
    // 缩放文本字体大小动画
    func fontsizeAnimat(_ font: UIFont, withDuration duration: TimeInterval) {
        let oldFontSize: CGFloat = self.font.pointSize
        let newFontSize: CGFloat = font.pointSize
        let scale: CGFloat = newFontSize / oldFontSize

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.layoutIfNeeded()

        }, completion: nil)

        transform = CGAffineTransform(scaleX: 1, y: 1)
        self.font = font
    }
}
