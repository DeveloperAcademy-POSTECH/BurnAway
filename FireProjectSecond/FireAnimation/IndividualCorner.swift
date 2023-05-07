//
//  IndividualCorner.swift
//  FireProjectSecond
//
//  Created by Kimjaekyeong on 2023/05/16.
//


import SwiftUI

struct IndividualCorner: Shape {
    
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii:CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    }

