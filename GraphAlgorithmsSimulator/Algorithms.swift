//
//  Algorithms.swift
//  GraphAlgorithmsSimulator
//
//  Created by Mohamed Mohamed on 8/9/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import Foundation


struct Pair {
    var first: Int
    var second: Int
}


class Algorithms {
    struct VertexInfo {
        var vertex: CGPoint //  pair<int, int> vertex;
        var distance = Double.infinity
        var precedingVertex: Int = 0
        var visited = false;
    }
    
    var totalWeight: Double = 0;
    
    static func calculateDistance(p1: CGPoint, p2: CGPoint) -> Double {
        let x = p1.x - p2.x
        let y = p1.y - p2.y
        return sqrt(Double(x) * Double(x) + Double(y) * Double(y));
    }
    
    func dijkstra(coordinates: [CGPoint]) -> [Pair] {
        var myPairs: [Pair] = []
        var verticesInfo: [VertexInfo] = []
        let numPoints = coordinates.count
        verticesInfo.reserveCapacity(numPoints)
        for coordinate in coordinates {
            var tempInfo: VertexInfo = VertexInfo(vertex: coordinate, distance: Double.infinity, precedingVertex: 0, visited: false)
            tempInfo.vertex = coordinate
            verticesInfo.append(tempInfo)
        }
        var falsePoints: [Int] = []
        falsePoints.reserveCapacity(numPoints)
        
        for i in 0..<numPoints {
            falsePoints.append(i)
        }
        
        return myPairs
    }
    func kruskals(coordinates: [CGPoint]) -> [Pair] {
        var myPairs: [Pair] = []
        var verticesInfo: [VertexInfo] = []
        let numPoints = coordinates.count
        verticesInfo.reserveCapacity(numPoints)
        for coordinate in coordinates {
            var tempInfo: VertexInfo = VertexInfo(vertex: coordinate, distance: Double.infinity, precedingVertex: 0, visited: false)
            tempInfo.vertex = coordinate
            verticesInfo.append(tempInfo)
        }
        var falsePoints: [Int] = []
        falsePoints.reserveCapacity(numPoints)
        
        for i in 0..<numPoints {
            falsePoints.append(i)
        }
        
        verticesInfo[0].distance = 0;
        var minDistance: Double
        var tempDistance = Double.infinity
        var minDistanceLocation: Int = 0;
        var minDistanceLocationInverticesInfo: Int = 0;
        totalWeight = 0;
        verticesInfo[0].distance = 0;
        var start = true;
        while (!falsePoints.isEmpty) {
            minDistance = Double.infinity
            // selects vertx having the smallest tentative distance
            for i in 0..<falsePoints.count {
                if verticesInfo[falsePoints[i]].distance < minDistance {
                    minDistance = verticesInfo[falsePoints[i]].distance
                    minDistanceLocation = i
                    minDistanceLocationInverticesInfo = falsePoints[i]
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
                if (minDistanceLocationInverticesInfo < verticesInfo[minDistanceLocationInverticesInfo].precedingVertex) {
                    let tempPair: Pair = Pair(first: minDistanceLocationInverticesInfo, second: verticesInfo[minDistanceLocationInverticesInfo].precedingVertex)
                    myPairs.append(tempPair)
                }
                else {
                    let tempPair: Pair = Pair(first: verticesInfo[minDistanceLocationInverticesInfo].precedingVertex, second: minDistanceLocationInverticesInfo)
                    myPairs.append(tempPair)
                }
            }
            else {
                start = false;
            }
            
            // sets it to true by deleting it from falsePoints
            falsePoints.remove(at: minDistanceLocation)
            
            for i in 0..<falsePoints.count {
                tempDistance = Algorithms.calculateDistance(p1: verticesInfo[falsePoints[i]].vertex, p2: verticesInfo[minDistanceLocationInverticesInfo].vertex)
                if (tempDistance < verticesInfo[falsePoints[i]].distance) {
                    verticesInfo[falsePoints[i]].precedingVertex = minDistanceLocationInverticesInfo;
                    verticesInfo[falsePoints[i]].distance = tempDistance;
                }
            }
        }
        return myPairs
    }
}
