//
//  ViewController.swift
//  Eagle-Eye
//
//  Created by David Park on 7/4/16.
//  Copyright © 2016 David Park. All rights reserved.
//

import UIKit
import PuzzleAnimation

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var buttonArray = [UIButton]()
    var round = 0
    var highscore = 0
    var lives = 5
    var randomColor = UIColor()
    var currentDimension: Int!
    var randomBlockIndex: Int!
    var livesLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
    private var backwardAnimation: PuzzleAnimation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextRound()
        
    }
    
    func setupGrid() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        //item size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        let blockDemension = (self.view.frame.width - 40 - 5*(CGFloat(currentDimension) - 1)) / CGFloat(currentDimension)
        layout.itemSize = CGSize(width: blockDemension, height: blockDemension)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.cloudsColor()          //cloudsColorDefault
        self.view.addSubview(collectionView)
        
    }
    
    func setupScene() {
        
        //livesLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
        livesLabel.text = "Lives: " + String(lives)
        self.view.addSubview(livesLabel)
        livesLabel.center = CGPointMake(self.view.frame.width/2, (12/16)*self.view.frame.height)
        livesLabel.textAlignment = NSTextAlignment.Center
        
        let roundLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
        roundLabel.text = "Round: " + String(round)
        self.view.addSubview(roundLabel)
        roundLabel.center = CGPointMake(self.view.frame.width/2, (13/16)*self.view.frame.height)
        roundLabel.textAlignment = NSTextAlignment.Center
        
    }
    
    func gameOverScene() {
        
        let resetButton = UIButton(frame: CGRectMake(0, 0, 200, 21))
        resetButton.setTitle("RESET", forState: .Normal)
        resetButton.addTarget(self, action: #selector(resetButtonPressed), forControlEvents: .TouchUpInside)
        resetButton.setTitleColor(UIColor.wetAsphaltColor(), forState: .Normal)
        self.view.addSubview(resetButton)
        resetButton.center = CGPointMake(self.view.frame.width/2, (7/8)*self.view.frame.height)
    }
    
    func resetButtonPressed(sender: UIButton) {
        round = 0
        lives = 5
        puzzleAnimate()
        nextRound()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfBoxes()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        let normalHexValues = randomColor.getHexComponent()
        let offsetValue = CGFloat(hexOffsetValue(round))
        let offSetColor = UIColor(red: normalHexValues![0] - offsetValue, green: normalHexValues![1] - offsetValue, blue: normalHexValues![2] - offsetValue, alpha: 1)
        if (indexPath.row == randomBlockIndex) {
            cell.backgroundColor = offSetColor
        } else {
            cell.backgroundColor = randomColor
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if (lives == 0 ) {
            return
        } else {
            if (indexPath.row == randomBlockIndex) {
                if ((round + 1) % 25 == 0) {                                    //+1 life every 25 levels
                    lives += 1                                                  //Need something to pop up and say +1
                }
                nextRound()
            } else {
                lives -= 1
                
                if (lives == 0) {
                    gameOverScene()
                    self.livesLabel.text = "Lives: " + String(lives)
                } else {
                    self.livesLabel.text = "Lives: " + String(lives)
                }
            }
        }
    }
    
    func numberOfBoxes() -> Int {
        return currentDimension * currentDimension
    }
    
    func nextRound() {
        
        randomColor = UIColor.randomCustomColor()
        round += 1
        
        currentDimension = generateDimensionsOfGrid(round)
        randomBlockIndex = Int(arc4random_uniform(UInt32(numberOfBoxes())))
        
        setupGrid()
        setupScene()
        
    }
    
    func puzzleAnimate() {
        var backwardConfiguration = PuzzleAnimationConfiguration()
        backwardConfiguration.animationVelocity = 20
        backwardConfiguration.pieceAnimationDelay = defaultBackwardPieceAnimationDelay
        backwardConfiguration.pieceGroupAnimationDelay = defaultBackwardPieceGroupAnimationDelay
        self.backwardAnimation = BackwardPuzzleAnimation(viewToAnimate: self.view, configuration: backwardConfiguration)
        self.backwardAnimation!.start()
    }
    

}

