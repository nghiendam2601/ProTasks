//
//  Config.swift
//  Pro Tasks
//
//  Created by DamMinhNghien on 6/8/24.
//

import UIKit

struct Config{
    
    static let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .medium)
    static let circleIcon = UIImage(systemName: "circle", withConfiguration: largeConfig)
    
    static let circleFillIcon = UIImage(systemName: "circle.fill", withConfiguration: largeConfig)
    static  let attributes: [NSAttributedString.Key: Any] = [
        .strikethroughStyle: NSUnderlineStyle.single.rawValue
    ]
    static let attributesNormal: [NSAttributedString.Key: Any] = [
       
        .font: UIFont.systemFont(ofSize: 18)
    ]
}
