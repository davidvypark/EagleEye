//
//  ViewController.swift
//  Eagle-Eye
//
//  Created by David Park on 7/4/16.
//  Copyright © 2016 David Park. All rights reserved.
//

import UIKit

var currentLevel: Int!

class ViewController: UIViewController {
    
    //let hexOffset: CGFloat!
    let randomRed = CGFloat(drand48())
    let randomGreen = CGFloat(drand48())
    let randomBlue = CGFloat(drand48())

    override func viewDidLoad() {
        super.viewDidLoad()
        generateButtons()
    }
    
    func colorButton(withColor color:UIColor) -> UIButton {
        let newButton = UIButton(type: .System)
        newButton.backgroundColor = color
        newButton.setTitle("Normal", forState: .Normal)
        newButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return newButton
    }
    
    func generateButtons(){
        currentLevel = 5
        var currentDimension = 5

        print(String(randomRed) + "__" + String(randomGreen) + "__" + String(randomBlue))
        //let randomButtonIndexToAlter = 1 + arc4random_uniform(3)
        
        //let basicRandomColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
        var buttonArray1 = [UIButton]()
        var buttonArray2 = [UIButton]()
        var buttonArray3 = [UIButton]()
        var buttonArray4 = [UIButton]()
        var buttonArray5 = [UIButton]()
        
        while (currentDimension > 0) {
            buttonArray1 += [colorButton(withColor: UIColor.blueColor())]
            buttonArray2 += [colorButton(withColor: UIColor.blueColor())]
            buttonArray3 += [colorButton(withColor: UIColor.blueColor())]
            buttonArray4 += [colorButton(withColor: UIColor.blueColor())]
            buttonArray5 += [colorButton(withColor: UIColor.blueColor())]
            
            currentDimension -= 1
        }
        
        //subviews
        let subStackView1 = UIStackView(arrangedSubviews: buttonArray1)
        subStackView1.axis = .Horizontal
        subStackView1.distribution = .FillEqually
        subStackView1.alignment = .Fill
        subStackView1.spacing = 5
        
        //another stackview

        let subStackView2 = UIStackView(arrangedSubviews: buttonArray2)
        subStackView2.axis = .Horizontal
        subStackView2.distribution = .FillEqually
        subStackView2.alignment = .Fill
        subStackView2.spacing = 5
        
        //yet another stackview
        
        let subStackView3 = UIStackView(arrangedSubviews: buttonArray3)
        subStackView3.axis = .Horizontal
        subStackView3.distribution = .FillEqually
        subStackView3.alignment = .Fill
        subStackView3.spacing = 5
        
        //and another one
        
        let subStackView4 = UIStackView(arrangedSubviews: buttonArray4)
        subStackView4.axis = .Horizontal
        subStackView4.distribution = .FillEqually
        subStackView4.alignment = .Fill
        subStackView4.spacing = 5
        
        //and another one
        
        let subStackView5 = UIStackView(arrangedSubviews: buttonArray5)
        subStackView5.axis = .Horizontal
        subStackView5.distribution = .FillEqually
        subStackView5.alignment = .Fill
        subStackView5.spacing = 5
        
        
        //some random buttons
//        
//        let blueButton = colorButton(withColor: UIColor.blueColor(), title: "Blue Button")
//        
//        let redButton = colorButton(withColor: UIColor.redColor(), title: "Red Button")
//        
//        let blackButton = colorButton(withColor: UIColor.blackColor(), title: "Black Button")
        
        
        let stackView = UIStackView(arrangedSubviews: [subStackView1, subStackView2, subStackView3, subStackView4, subStackView5])
        stackView.axis = .Vertical
        stackView.distribution = .FillEqually
        stackView.alignment = .Fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
    
        
        //this constrainswithvisualformat thing is pretty cool
        let viewsDictionary = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[stackView]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[stackView]-20-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        view.addConstraints(stackView_H)
        view.addConstraints(stackView_V)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

