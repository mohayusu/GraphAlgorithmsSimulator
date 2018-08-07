//
//  Line.swift
//  GraphAlgorithmsSimulator
//
//  Created by Mohamed Mohamed on 8/4/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class LinesAndPoints: UIView {
    struct PropertyKeys {
        static let pointDiameter = 15
    }
    
    var line = UIBezierPath()
    var coordinates: [CGPoint] = []
    
    func addPoint(coordinate: CGPoint) {
        coordinates.append(coordinate)
    }
    
    func updateView() {
        self.setNeedsDisplay()
    }
    
    func printLines() {
        for i in coordinates {
            print(i)
        }
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.red.setStroke()
        if coordinates.count >= 2 {
            
            line.lineWidth = 1.5
           // for (index, i) in coordinates.enumerated() {
                for j in coordinates.reversed() {
                    line.move(to: .init(x: coordinates[coordinates.count - 1].x, y: coordinates[coordinates.count - 1].y))
                    line.addLine(to: .init(x: j.x, y: j.y))
                    line.stroke()
                }
           // }
            
        }
    }

}
