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
    var isInFinalGraph: Bool
    var savePointTemporarily: Bool?
}

struct Visited {
    var visited: Bool
}


class Algorithms {
    struct PropertyKeys {
        static let kruskal = "Kruskal"
        static let dijkstra = "Dijkstra"
    }
    
    struct VertexInfo {
        var vertex: CGPoint //  pair<int, int> vertex;
        var distance = Double.infinity
        var precedingVertex: Int
    }
    
    var totalWeight: Double = 0
    var currentStep: Int = 0
    var cache: [Visited] = []
    
    static func calculateDistance(p1: CGPoint, p2: CGPoint) -> Double {
        let x = p1.x - p2.x
        let y = p1.y - p2.y
        return sqrt(Double(x) * Double(x) + Double(y) * Double(y));
    }

///////////////////////////////////////////////////////////////////////////////////////////////////////////
    /* DFS to check if graph is connected */
    
    func isConnected(connections: [Int: [Int]], numPoints: Int) -> Bool {
        for _ in 0...numPoints {
            cache.append(Visited(visited: false))
        }

        search(connections: connections, root: Array(connections.keys)[0])
        
        for i in 1...numPoints {
            if cache[i].visited == false {
                return false
            }
        }
        
        return true
    }
    
    func search(connections: [Int: [Int]], root: Int) {
        if root > connections.count || root < 1 {
            return
        }
        cache[root].visited = true
        for connectingEnd in connections[root]! {
            if cache[connectingEnd].visited == false {
                search(connections: connections, root: connectingEnd)
            }
        }
    }
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func dijkstra(points: [UIButton], connections: [Int: [Int]], destination: Int) -> [Pair] {
        var myPairs: [Pair] = []
        var verticesInfo: [VertexInfo] = []
        let numPoints = points.count
        verticesInfo.reserveCapacity(numPoints)
        for point in points {
            var tempInfo: VertexInfo = VertexInfo(vertex: point.center, distance: Double.infinity,
                                                  precedingVertex: -1)
            tempInfo.vertex = point.center
            verticesInfo.append(tempInfo)
        }
        
        var falsePoints: [Int] = []
        falsePoints.reserveCapacity(numPoints)
        
        for i in 0..<numPoints {
            falsePoints.append(i)
        }
        
        for _ in 0..<numPoints {
            cache.append(Visited(visited: false))
        }
        
        verticesInfo[0].distance = 0
        cache[0].visited = true
        var currentPoint: Int? = 0
        
        while currentPoint != nil {
            for connectingEnd in connections[currentPoint! + 1]! {
                let connectingDistance = Algorithms.calculateDistance(p1: points[currentPoint!].center,
                                                                p2: points[connectingEnd - 1].center)
                let totalDistance = connectingDistance + verticesInfo[currentPoint!].distance
                
                if verticesInfo[connectingEnd - 1].distance > totalDistance {
                    verticesInfo[connectingEnd - 1].distance = totalDistance
                    verticesInfo[connectingEnd - 1].precedingVertex = currentPoint!
                }
            }
            
            cache[currentPoint!].visited = true
            
            if currentPoint! == destination {
                print("destination \(destination)")
                totalWeight = verticesInfo[destination].distance
                var precedingLocation = verticesInfo[destination].precedingVertex
                
                while precedingLocation != -1 {
                    let aPair = Pair(first: precedingLocation, second: currentPoint!, isInFinalGraph: true, savePointTemporarily: nil)
                    myPairs.append(aPair)
                    currentPoint = precedingLocation
                    precedingLocation = verticesInfo[currentPoint!].precedingVertex
                }
                return myPairs
            }
                
            var minDistance = Double.infinity
            var nextCurrentPoint: Int = currentPoint!
            for (index, vertex) in cache.enumerated() {
                if !vertex.visited && verticesInfo[index].distance < minDistance {
                    nextCurrentPoint = index
                    minDistance = verticesInfo[index].distance
                }
            }
      
          //  let aPair = Pair(first: currentPoint!, second: nextCurrentPoint, isInFinalGraph: true, savePointTemporarily: nil)
          //  myPairs.append(aPair)
                
            currentPoint = nextCurrentPoint
            
            if minDistance == Double.infinity {
                currentPoint = nil
            }
        }
        return myPairs
    }
    
    
    func kruskals(points: [UIButton], connections: [Int: [Int]], isConnected: Bool) -> [Pair] {
        var myPairs: [Pair] = []
        var verticesInfo: [VertexInfo] = []
        let numPoints = points.count
        verticesInfo.reserveCapacity(numPoints)
        for point in points {
            var tempInfo: VertexInfo = VertexInfo(vertex: point.center, distance: Double.infinity,
                                                  precedingVertex: -1)
            tempInfo.vertex = point.center
            verticesInfo.append(tempInfo)
        }
        verticesInfo[0].precedingVertex = 0
        var falsePoints: [Int] = []
        falsePoints.reserveCapacity(numPoints)
        
        for i in 0..<numPoints {
            falsePoints.append(i)
        }
        
        verticesInfo[0].distance = 0
        var minDistance: Double
        var tempDistance = Double.infinity
        var minDistanceLocation: Int = 0
        var minDistanceLocationInverticesInfo: Int = 0
        totalWeight = 0
        verticesInfo[0].distance = 0
        var start = true
        while (!falsePoints.isEmpty) {
            minDistance = Double.infinity
            // selects vertex having the smallest tentative distance
            for i in 0..<falsePoints.count {
                if (verticesInfo[falsePoints[i]].precedingVertex != -1) {
                    var aPair = Pair(first: falsePoints[i], second: verticesInfo[falsePoints[i]].precedingVertex, isInFinalGraph: false, savePointTemporarily: false)
                    if verticesInfo[falsePoints[i]].distance < minDistance {
                        aPair.savePointTemporarily = true
                        minDistance = verticesInfo[falsePoints[i]].distance
                        minDistanceLocation = i
                        minDistanceLocationInverticesInfo = falsePoints[i]
                    }
                    // so we don't add (0, 0) in myPairs
                    if (verticesInfo[falsePoints[i]].precedingVertex != 0 && i != 0) {
                        myPairs.append(aPair)
                    }
                }
            }
            
            // if there wasn't any minimum distances found
            if (minDistance == Double.infinity) {
                print("invalid")
                for i in falsePoints {
                    print(i)
                }
                exit(1);
            }
            
            totalWeight += (minDistance * 2);
            // !start just makes sure we don't print out (0, 0)
            if (!start) {
                let tempPair: Pair = Pair(first: minDistanceLocationInverticesInfo, second: verticesInfo[minDistanceLocationInverticesInfo].precedingVertex, isInFinalGraph: true, savePointTemporarily: nil)
                myPairs.append(tempPair)
            }
            else {
                start = false;
            }
            
            let nextTrue = falsePoints[minDistanceLocation]
            // sets it to true by deleting it from falsePoints
            falsePoints.remove(at: minDistanceLocation)
            
            for i in 0..<falsePoints.count {
                if (connections[nextTrue + 1]?.contains(falsePoints[i] + 1))! {
                    let aPair = Pair(first: falsePoints[i], second: minDistanceLocationInverticesInfo,
                                     isInFinalGraph: false, savePointTemporarily: false)
                    tempDistance = Algorithms.calculateDistance(p1: verticesInfo[falsePoints[i]].vertex, p2: verticesInfo[minDistanceLocationInverticesInfo].vertex)
                    if (tempDistance < verticesInfo[falsePoints[i]].distance) {
                        verticesInfo[falsePoints[i]].precedingVertex = minDistanceLocationInverticesInfo;
                        verticesInfo[falsePoints[i]].distance = tempDistance;
                    }
                    myPairs.append(aPair)
                }
            }
        }
        return myPairs
    }
}
