//
//  Algorithms.swift
//  GraphAlgorithmsSimulator
//
//  Created by Mohamed Mohamed on 8/9/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//  mohayusu

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
        var vertex: CGPoint
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
}
