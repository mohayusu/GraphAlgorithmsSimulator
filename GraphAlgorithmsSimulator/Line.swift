//
//  Line.swift
//  GraphAlgorithmsSimulator
//
//  Created by Mohamed Mohamed on 8/4/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class Line: UIView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var line = UIBezierPath()
    var coordinates: [CGPoint] = []
    
    func addPoint(coordinate: CGPoint) {
        coordinates.append(coordinate)
    }
    
    func printLines() {
        for i in coordinates {
            print(i)
        }
    }
    
    override func draw(_ rect: CGRect) {

    }

}
