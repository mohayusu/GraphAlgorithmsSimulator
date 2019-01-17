//
//  ShortestPathAlgorithms.swift
//  GraphAlgorithmsSimulator
//
//  Created by Mohamed Mohamed on 1/16/19.
//  Copyright © 2019 Mohamed Mohamed. All rights reserved.
//

import Foundation


class ShortestPathAlgorithms: Algorithms {
    func dijkstra(points: [UIButton], connections: [Int: [Int]], startingLocation: Int, destination: Int) -> [Pair] {
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
        
        verticesInfo[startingLocation].distance = 0
        cache[startingLocation].visited = true
        var currentPoint: Int? = startingLocation
        
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
            
            currentPoint = nextCurrentPoint
            
            if minDistance == Double.infinity {
                currentPoint = nil
            }
        }
        return myPairs
    }
}
