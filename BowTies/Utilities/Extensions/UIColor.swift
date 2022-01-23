//
//  UIColor.swift
//  BowTies
//
//  Created by Stanislav Lemeshaev on 15.01.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func from(dictionary: [String: Any]) -> UIColor? {
        guard let red = dictionary["red"] as? NSNumber,
              let green = dictionary["green"] as? NSNumber,
              let blue = dictionary["blue"] as? NSNumber else {
                  return nil
              }
        
        return UIColor(red: CGFloat(truncating: red) / 255.0,
                       green: CGFloat(truncating: green) / 255.0,
                       blue: CGFloat(truncating: blue) / 255.0,
                       alpha: 1)
    }
}
