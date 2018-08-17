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
        static let pointDiameter = 25
    }
    
    struct ConnectingPoint {
        var point1: CGPoint
        var point2: CGPoint
    }
    
    var coordinates: [CGPoint] = []
    var allPoints: [UIButton] = []
    var numPoints: Int = 0
    var weightOfPathString: String = ""
    var delegate: LinesAndPointsDelegate?
    var drawFinalGraph = false
    var connectingPoints: [ConnectingPoint] = []
    
    func addPoint(coordinate: CGPoint) {
        coordinates.append(coordinate)
        numPoints += 1
    }
    
    func addButton(button: UIButton) {
        allPoints.append(button)
    }
    
    func connectPoints(p1: CGPoint, p2: CGPoint) {
        let connection = ConnectingPoint(point1: p1, point2: p2)
        connectingPoints.append(connection)
        updateView(isFinal: false)
    }
    
    func isConnectedGraph() -> Bool {
        print("\(connectingPoints.count) \(allPoints.count)")
        return (connectingPoints.count + 1) >= allPoints.count
        // visited
    }
    
    func clearScreen() {
        coordinates.removeAll()
        allPoints.removeAll()
        subviews.forEach({ $0.removeFromSuperview() }) // removes points
        numPoints = 0
        updateView(isFinal: false) // removes lines; numPoints is 0
    }
    
    func updateView(isFinal: Bool) {
        drawFinalGraph = false
        if isFinal {
            drawFinalGraph = true
        }
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
            if drawFinalGraph {
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
            } else  {
                let line = UIBezierPath()
                UIColor.brown.setStroke()
                line.lineWidth = 1.5
                for i in connectingPoints {
                    line.move(to: i.point1)
                    line.addLine(to: i.point2)
                    line.stroke()
                }
            }
        }
    }

}
