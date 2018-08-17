//
//  Line.swift
//  GraphAlgorithmsVisualizer
//
//  Created by Mohamed Mohamed on 8/3/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class Graph: UIView {
    
    var line = UIBezierPath()
    
    
    // Draws the lines of the graph
    func graph() {
        var currX: CGFloat = 0
        var currY: CGFloat = 0
        
        // draws vertical line in the middle of the screen
        line.move(to: .init(x: bounds.width / 2, y: 0))
        line.addLine(to: .init(x: bounds.width / 2, y: bounds.height))
        UIColor.black.setStroke()
        line.lineWidth = 1.5
        line.stroke()
        
        var axisLabel = UILabel(frame: CGRect(x: bounds.width / 2 + 5, y: 0, width: 10, height: 10))
        // label.center = CGPoint(x: 160, y: 285)
        axisLabel.textAlignment = .center
        axisLabel.text = "\(bounds.height)"
        axisLabel.sizeToFit()
        addSubview(axisLabel)
        
        axisLabel = UILabel(frame: CGRect(x: bounds.width / 2 + 5, y: bounds.height - 20, width: 10, height: 10))
        axisLabel.textAlignment = .center
        axisLabel.text = "-\(bounds.height)"
        axisLabel.sizeToFit()
        addSubview(axisLabel)
        
        
        
        // draws a horizontal line in the middle of the screen
        line.move(to: .init(x: 0, y: bounds.height / 2))
        line.addLine(to: .init(x: bounds.width, y: bounds.height / 2))
        UIColor.black.setStroke()
        line.lineWidth = 1.5
        line.stroke()
        
        axisLabel = UILabel(frame: CGRect(x: 0, y: bounds.height / 2 + 10, width: 10, height: 10))
        // label.center = CGPoint(x: 160, y: 285)
        axisLabel.textAlignment = .center
        axisLabel.text = "-\(bounds.width)"
        axisLabel.sizeToFit()
        addSubview(axisLabel)
        
        axisLabel = UILabel(frame: CGRect(x: bounds.width - 60, y: bounds.height / 2 + 10, width: 10, height: 10))
        axisLabel.textAlignment = .center
        axisLabel.text = "\(bounds.width)"
        axisLabel.sizeToFit()
        addSubview(axisLabel)
        
        
        // draws vertical lines left of the middle
        currX = bounds.width / 2 - 20
        while currX > 0 {
            line.move(to: .init(x: currX, y: currY))
            line.addLine(to: .init(x: currX, y: bounds.height))
            UIColor.black.setStroke()
            line.lineWidth = 0.01
            line.stroke()
            currX -= 20
        }
        
        // draws vertical lines right of the middle
        currX = bounds.width / 2 + 20
        while currX < bounds.width {
            line.move(to: .init(x: currX, y: currY))
            line.addLine(to: .init(x: currX, y: bounds.height))
            UIColor.black.setStroke()
            line.lineWidth = 0.01
            line.stroke()
            currX += 20
        }
        
        // draws horizontal lines above the middle
        currY = bounds.height / 2 - 20
        currX = 0
        while currY > 0 {
            line.move(to: .init(x: currX, y: currY))
            line.addLine(to: .init(x: bounds.width, y: currY))
            UIColor.black.setStroke()
            line.lineWidth = 0.01
            line.stroke()
            currY -= 20
        }
        
        // draws horizontal lines below the middle
        
        currY = bounds.height / 2 + 20
        currX = 0
        while currY < bounds.height {
            line.move(to: .init(x: currX, y: currY))
            line.addLine(to: .init(x: bounds.width, y: currY))
            UIColor.black.setStroke()
            line.lineWidth = 0.01
            line.stroke()
            currY += 20
        }
    }
    
    override func draw(_ rect: CGRect) {
        graph()
    }
}















































