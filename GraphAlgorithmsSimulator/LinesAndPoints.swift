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
    var numPoints: Int = 0
    
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
    
    struct info {
        var vertex: CGPoint //  pair<int, int> vertex;
        var distance = Double.infinity
        var precedingVertex: Int = 0
        var visited = false;
    }
    
    struct Pair {
        var first: Int
        var second: Int
    }
    
    
    
    func calculateDistance(p1: CGPoint, p2: CGPoint) -> Double {
        let x = p1.x - p2.x
        let y = p1.y - p2.y
        return sqrt(Double(x) * Double(x) + Double(y) * Double(y));
    }
    
    var myPairs: [Pair] = []
    func kruskals() {
        var vertexInfo: [info] = []
        let numPoints = coordinates.count
        vertexInfo.reserveCapacity(numPoints)
        for coordinate in coordinates {
            var tempInfo: info = info(vertex: coordinate, distance: Double.infinity, precedingVertex: 0, visited: false)
            tempInfo.vertex = coordinate
            vertexInfo.append(tempInfo)
        }
        var falsePoints: [Int] = []
        falsePoints.reserveCapacity(numPoints)
        
        for i in 0..<numPoints {
            falsePoints.append(i)
        }
        
        vertexInfo[0].distance = 0;
        var minDistance: Double
        var tempDistance = Double.infinity
        var minDistanceLocation: Int = 0;
        var minDistanceLocationInVertexInfo: Int = 0;
        var totalWeight: Double = 0;
        vertexInfo[0].distance = 0;
        var start = true;
        while (!falsePoints.isEmpty) {
            minDistance = Double.infinity
            // selects vertx having the smallest tentative distance
            for i in 0..<falsePoints.count {
                if vertexInfo[falsePoints[i]].distance < minDistance {
                    minDistance = vertexInfo[falsePoints[i]].distance
                    minDistanceLocation = i
                    minDistanceLocationInVertexInfo = falsePoints[i]
                }
            }
            // if there wasn't any minimum distances found
            if (minDistance == Double.infinity) {
                print("invalid")
                exit(1);
            }
            
            totalWeight += minDistance;
            // !start just makes sure we don't print out (0, 0)
            if (!start) {
                if (minDistanceLocationInVertexInfo < vertexInfo[minDistanceLocationInVertexInfo].precedingVertex) {
                    let tempPair: Pair = Pair(first: minDistanceLocationInVertexInfo, second: vertexInfo[minDistanceLocationInVertexInfo].precedingVertex)
                    myPairs.append(tempPair)
                }
                else {
                    let tempPair: Pair = Pair(first: vertexInfo[minDistanceLocationInVertexInfo].precedingVertex, second: minDistanceLocationInVertexInfo)
                    myPairs.append(tempPair)
                }
            }
            else {
                start = false;
            }
            
            // sets it to true by deleting it from falsePoints
            falsePoints.remove(at: minDistanceLocation)
            
            for i in 0..<falsePoints.count {
                tempDistance = calculateDistance(p1: vertexInfo[falsePoints[i]].vertex, p2: vertexInfo[minDistanceLocationInVertexInfo].vertex)
                if (tempDistance < vertexInfo[falsePoints[i]].distance) {
                    vertexInfo[falsePoints[i]].precedingVertex = minDistanceLocationInVertexInfo;
                    vertexInfo[falsePoints[i]].distance = tempDistance;
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.red.setStroke()
        if coordinates.count > 2 {
            line.lineWidth = 1.5
            kruskals()
            for i in myPairs {
                line.move(to: coordinates[i.first])
                line.addLine(to: coordinates[i.second])
                line.stroke()
            }
        }
    }

}
