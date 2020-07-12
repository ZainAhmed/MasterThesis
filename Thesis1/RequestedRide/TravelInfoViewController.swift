//
//  TravelInfoViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 19.04.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
class TravelInfoViewController: UIViewController {
    
//    @IBOutlet weak var arrivingTime: UILabel!
    @IBOutlet weak var noPlate: UILabel!
    
    @IBOutlet weak var carColor: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var currentLocationLbl: UILabel!
    @IBOutlet weak var walkingToDestinationLbl: UILabel!
    @IBOutlet weak var dropOffLbl: UILabel!
    @IBOutlet weak var pickupLbl: UILabel!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var walkingtoPickupLbl: UILabel!
   
    let yellow = UIColor(red: 255.0/255.0, green: 192.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    let blue = UIColor(red: 1.0/255.0, green: 77.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    func setupElements(){
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 6
        self.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        createVerticaLines(startPoint: 120, endPoint: 200, fillColor: blue,pattern: [1,5])
        createVerticaLines(startPoint: 200, endPoint: 310, fillColor: blue, pattern: [1,0])
        createVerticaLines(startPoint: 310, endPoint: 390, fillColor: blue,pattern: [1,5])
        drawCircle(xCenter: 70 , yCenter: 120, fillColor: UIColor.white, strokeColor: blue, circleRadius: 3.0)
        drawCircle(xCenter: 70 , yCenter: 200, fillColor: blue, strokeColor: blue, circleRadius: 3.0)
        drawCircle(xCenter: 70 , yCenter: 310, fillColor: blue, strokeColor: blue, circleRadius: 3.0)
        drawCircle(xCenter: 70 , yCenter: 390, fillColor: UIColor.white, strokeColor: blue, circleRadius: 3.0)
    }
    
    func createVerticaLines(startPoint: CGFloat, endPoint: CGFloat, fillColor: UIColor,pattern: [NSNumber]){
        let layer = self.view.layer
        let lineDashPatterns: [[NSNumber]?]  = [ pattern]

        for (index, lineDashPattern) in lineDashPatterns.enumerated() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = fillColor.cgColor
            shapeLayer.lineWidth = 1.5
            shapeLayer.lineCap = CAShapeLayerLineCap.round
            shapeLayer.lineDashPattern = lineDashPattern
            let path = CGMutablePath()
            let x = CGFloat((index+1) * 70)
            path.addLines(between: [CGPoint(x: x, y: startPoint),
                                    CGPoint(x: x, y: endPoint)])
            shapeLayer.path = path
            layer.addSublayer(shapeLayer)
        }
    }
    
    func drawCircle(xCenter: CGFloat, yCenter: CGFloat, fillColor: UIColor, strokeColor: UIColor, circleRadius: Double){
        let path = CGMutablePath()
        let radius: Double = circleRadius
        let shapeLayer = CAShapeLayer()
        let center = CGPoint(x: xCenter, y: yCenter)
        path.move(to: CGPoint(x: center.x  + CGFloat(radius), y: center.y ))
        
        for i in stride(from: 0, to: 361.0, by: 10) {
            let radians = i*Double.pi/180
            let xVal = Double(center.x) + radius * cos(radians)
            let yVal = Double(center.y) + radius * sin(radians)
            path.addLine(to: CGPoint(x: xVal, y: yVal))
        }
        
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = path
        self.view.layer.addSublayer(shapeLayer)
    }
}
