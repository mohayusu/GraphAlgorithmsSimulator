//
//  Line.swift
//  GraphAlgorithmsSimulator
//
//  Created by Mohamed Mohamed on 8/4/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

protocol LinesAndPointsDelegate {
    func showValue(str: String)
}

class LinesAndPoints: UIView {
    struct PropertyKeys {
        static let pointDiameter = 15
    }
    
    var coordinates: [CGPoint] = []
    var numPoints: Int = 0
    var weightOfPathString: String = ""
    var delegate: LinesAndPointsDelegate?
    
    func addPoint(coordinate: CGPoint) {
        coordinates.append(coordinate)
        numPoints += 1
    }
    
    func clearScreen() {
        coordinates.removeAll()
        subviews.forEach({ $0.removeFromSuperview() }) // removes points
        numPoints = 0
        updateView() // removes lines; numPoints is 0
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
        if coordinates.count > 2 {
            let line = UIBezierPath()
            let algorithm = Algorithms()
            line.lineWidth = 1.5
            let myPairs: [Pair] = algorithm.kruskals(coordinates: coordinates)
            for i in myPairs {
                line.move(to: coordinates[i.first])
                line.addLine(to: coordinates[i.second])
                line.stroke()
            }
            weightOfPathString = String(format: "%.2f", algorithm.totalWeight)
            delegate?.showValue(str: weightOfPathString)
        }
    }

}
