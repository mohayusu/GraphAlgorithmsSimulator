//
//  Line.swift
//  GraphAlgorithmsSimulator
//
//  Created by Mohamed Mohamed on 8/4/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

protocol LinesAndPointsDelegate {
    func showFinalWeightValue(str: String)
}

class LinesAndPoints: UIView {
    struct PropertyKeys {
        static let pointDiameter = 25
    }
    
    var allPoints: [UIButton] = []
    var allLineConnections: [Pair] = []
    var numPoints: Int = 0
    var weightOfPathString: String = ""
    var delegate: LinesAndPointsDelegate?
    var drawFinalGraph = false
    var drawNextStep = false
    var connectingPointsCollection: [Int : [Int]] = [:]
    var algorithm = Algorithms()
    
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
    
    func clearScreen() {
        allPoints.removeAll()
        connectingPointsCollection.removeAll()
        subviews.forEach({ $0.removeFromSuperview() }) // removes points
        numPoints = 0
        currStep = 0
        updateView(isFinal: false) // removes lines; numPoints is 0
    }
    
    func updateView(isFinal: Bool) {
        drawFinalGraph = false
        drawNextStep = false
        if isFinal {
            drawFinalGraph = true
        }
        self.setNeedsDisplay()
    }
    
    func updateViewSteps() {
        drawNextStep = true
        drawFinalGraph = false
        
        self.setNeedsDisplay()
    }
    
    func performAlgorithm(chosenAlgorithm: String) {
        algorithm = Algorithms()
        switch chosenAlgorithm {
            case Algorithms.PropertyKeys.kruskal:
                allLineConnections = algorithm.kruskals(points: allPoints, connections: connectingPointsCollection, isConnected: true)
            default:
                allLineConnections = algorithm.dijkstra(points: allPoints, connections: connectingPointsCollection, destination: 3)
        }
    }
    
    func showFinalGraph() {
        let line = UIBezierPath()
        line.lineWidth = 1.5
        for i in allLineConnections {
            if i.savePointTemporarily == nil { // this being nill signifies that the point is in the final graph
                print(i)
                line.move(to: allPoints[i.first].center)
                line.addLine(to: allPoints[i.second].center)
                line.stroke()
            }
        }
        weightOfPathString = String(format: "%.2f", algorithm.totalWeight)
        delegate?.showFinalWeightValue(str: weightOfPathString)
    }
    
    func showGraphWithNextConnection() {
        let line = UIBezierPath()
        UIColor.blue.setStroke()
        line.lineWidth = 1.5
        for connectionKey in connectingPointsCollection.keys {
            for connectionValue in connectingPointsCollection[connectionKey]! {
                line.move(to: allPoints[connectionKey - 1].center)
                line.addLine(to: allPoints[connectionValue - 1].center)
                line.stroke()
            }
        }
    }
    
    
    var currStep: Int = 0
    var savedPointLocationIndex: Int?
    func updateGraphWithNextStep() {
        currStep += 1
        
        if currStep == allLineConnections.count - 1 {
            updateView(isFinal: true)
            currStep -= 1
            return
        }
        
        let line = UIBezierPath()
        UIColor.blue.setStroke()
        line.lineWidth = 1.5
        
        // we save a new line so we should get rid of the one we were already saving
        if (savedPointLocationIndex != nil && allLineConnections[currStep - 1].savePointTemporarily != nil &&
                allLineConnections[currStep - 1].savePointTemporarily == true) || currStep - 1 == allLineConnections.count {
            savedPointLocationIndex = nil
        }
        
        for index in 0..<currStep {
            print(allLineConnections)
            let i = allLineConnections[index]
            
            // this being nill signifies that the point is in the final graph
            if i.savePointTemporarily == nil {
                UIColor.red.setStroke()
                line.move(to: allPoints[i.first].center)
                line.addLine(to: allPoints[i.second].center)
                line.stroke()
                UIColor.blue.setStroke()
            } else if savedPointLocationIndex != nil && index == savedPointLocationIndex {
                line.move(to: allPoints[i.first].center)
                line.addLine(to: allPoints[i.second].center)
                line.stroke()
            } else if i.savePointTemporarily == true || index == currStep - 1 {
                if i.savePointTemporarily == true {
                    savedPointLocationIndex = index
                }
                line.move(to: allPoints[i.first].center)
                line.addLine(to: allPoints[i.second].center)
                line.stroke()
            }
            
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.red.setStroke()
        if numPoints >= GraphViewController.PropertyKeys.minPointsToBegin {
            if drawFinalGraph {
               showFinalGraph()
            } else if drawNextStep {
                updateGraphWithNextStep()
                if drawFinalGraph {
                    showFinalGraph()
                }
            } else  {
               showGraphWithNextConnection()
            }
        }
    }

}
