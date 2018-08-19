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
    
    var allPoints: [UIButton] = []
    var numPoints: Int = 0
    var weightOfPathString: String = ""
    var delegate: LinesAndPointsDelegate?
    var drawFinalGraph = false
    var connectingPointsCollection: [Int : [Int]] = [:]
    
    func addPoint(button: UIButton) {
        allPoints.append(button)
        numPoints += 1
    }
    
    func connectPointsUndirected(p1: UIButton, p2: UIButton) {
        guard let title1 = p1.currentTitle else { return }
        guard let title2 = p2.currentTitle else { return }
        
        guard let num1 = Int(title1) else { return }
        guard let num2 = Int(title2) else { return }
        
        if connectingPointsCollection[num1] == nil {
            connectingPointsCollection[num1] = []
        }
        if connectingPointsCollection[num2] == nil {
            connectingPointsCollection[num2] = []
        }
        
        connectingPointsCollection[num1]?.append(num2)
        connectingPointsCollection[num2]?.append(num1)
        
        updateView(isFinal: false)
    }
    
    func addConnectionToCompleteGraph(num: Int) {
        // adds the number to all collections
        connectingPointsCollection[num] = []
        for connectionKey in connectingPointsCollection.keys {
            if connectionKey != num {
                connectingPointsCollection[connectionKey]?.append(num)
                connectingPointsCollection[num]?.append(connectionKey)
            }
        }
    }
    
    func isConnectedGraph() -> Bool {
        /*print("\(connectingPoints.count) \(allPoints.count)")
        return (connectingPoints.count + 1) >= allPoints.count*/
        return true
        // visited
    }
    
    func clearScreen() {
        allPoints.removeAll()
        connectingPointsCollection.removeAll()
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
       /* for i in coordinates {
            print(i)
        }*/
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.red.setStroke()
        if numPoints > 2 {
            if drawFinalGraph {
                let line = UIBezierPath()
                let algorithm = Algorithms()
                line.lineWidth = 1.5
                let myPairs: [Pair] = algorithm.kruskals(points: allPoints, connections: connectingPointsCollection, isConnected: true)
                for i in myPairs {
                    line.move(to: allPoints[i.first].center)
                    line.addLine(to: allPoints[i.second].center)
                    line.stroke()
                }
                weightOfPathString = String(format: "%.2f", algorithm.totalWeight)
                delegate?.showValue(str: weightOfPathString)
            } else  {
                let line = UIBezierPath()
                UIColor.brown.setStroke()
                line.lineWidth = 1.5
                for connectionKey in connectingPointsCollection.keys {
                    for connectionValue in connectingPointsCollection[connectionKey]! {
                        line.move(to: allPoints[connectionKey - 1].center)
                        line.addLine(to: allPoints[connectionValue - 1].center)
                        line.stroke()
                    }
                }
               /* for i in connectingPoints {
                    line.move(to: i.point1)
                    line.addLine(to: i.point2)
                    line.stroke()
                }*/
            }
        }
    }

}
