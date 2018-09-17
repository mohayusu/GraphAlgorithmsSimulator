//
//  RedLine.swift
//  GraphAlgorithmsSimulator
//
//  Created by Mohamed Mohamed on 9/1/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//  mohayusu
import UIKit

struct LinePair {
    var point1: CGPoint
    var point2: CGPoint
}

class RedLine: UIView {
    struct PropertyKeys {
        static let redLineTag = 1
    }
    var lines: [LinePair] = []
    
    func addLine(point1: CGPoint, point2: CGPoint) {
        let tempLinePair = LinePair(point1: point1, point2: point2);
        // prevents adding same line two times in a row
        if lines.isEmpty || (tempLinePair.point1 != lines[lines.count - 1].point1 ||
            tempLinePair.point2 != lines[lines.count - 1].point2) {
            lines.append(tempLinePair);
        }
    }
    
    func removeLastLine() {
        lines.removeLast()
        self.setNeedsDisplay()
    }
    
    func drawRedLines() {
        self.setNeedsDisplay()
    }
    
    func removeAllLines() {
        lines.removeAll()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let line = UIBezierPath()
        line.lineWidth = 1.5
        UIColor.red.setStroke()
        for connection in lines {
            line.move(to: connection.point1)
            line.addLine(to: connection.point2)
            line.stroke()
        }
    }

}
