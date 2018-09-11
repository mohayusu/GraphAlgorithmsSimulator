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
    func addRedLineBetween(point1: CGPoint, point2: CGPoint)
    func drawRedLines()
    func removeLastRedLine()
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
    
    // connects two points in a non-connected graph
    func connectPointsNotConnectedGraph(p1: UIButton, p2: UIButton) {
        // the title of the button represents its number
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
        subviews.forEach({ // removes points
            if $0.tag != RedLine.PropertyKeys.redLineTag {
                $0.removeFromSuperview()
            }
            
        })
        numPoints = 0
        currStep = 0
        savedPointLocationIndex = nil;
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
                allLineConnections = algorithm.kruskals(points: allPoints,
                                                        connections: connectingPointsCollection, isConnected: true)
            default:
                allLineConnections = algorithm.dijkstra(points: allPoints,
                                                        connections: connectingPointsCollection, destination: 3)
        }
    }
    
    func showFinalGraph() {
        for index in currStep..<allLineConnections.count {
            let i = allLineConnections[index]
            if i.isInFinalGraph {
                delegate?.addRedLineBetween(point1: allPoints[i.first].center,
                                            point2: allPoints[i.second].center)
            }
        }
        delegate?.drawRedLines()
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
        // it's the final step, so we just show the final graph
        if currStep == allLineConnections.count {
            updateView(isFinal: true)
            return
        }
        
        let line = UIBezierPath()
        UIColor.blue.setStroke()
        line.lineWidth = 1.5
        
        // we save a new line so we should get rid of the one we were already saving
        if (savedPointLocationIndex != nil && !allLineConnections[currStep].isInFinalGraph &&
                allLineConnections[currStep].savePointTemporarily == true) ||
                currStep == allLineConnections.count {
            savedPointLocationIndex = nil
        }
        
        for index in 0...currStep {
            let currConnection = allLineConnections[index]
            
            if currConnection.isInFinalGraph && index == currStep {
                delegate?.addRedLineBetween(point1: allPoints[currConnection.first].center,
                                            point2: allPoints[currConnection.second].center)
            } else if index == currStep ||
                      (savedPointLocationIndex != nil && index == savedPointLocationIndex) {
                if index == currStep && currConnection.savePointTemporarily == true {
                    savedPointLocationIndex = index
                }
                line.move(to: allPoints[currConnection.first].center)
                line.addLine(to: allPoints[currConnection.second].center)
                line.stroke()
            }
        }
        delegate?.drawRedLines()
        currStep += 1
    }
    
    func decreaseCurrStep() {
        if currStep > 1 {
            if allLineConnections[currStep - 1].isInFinalGraph {
                delegate?.removeLastRedLine()
            }
            currStep -= 2
            updateViewSteps()
        }
    }
    
    override func draw(_ rect: CGRect) {
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
