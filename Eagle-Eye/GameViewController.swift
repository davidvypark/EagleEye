//
//  GameViewController.swift
//  Eagle-Eye
//
//  Created by David Park on 7/4/16.
//  Copyright © 2016 David Park. All rights reserved.
//

import UIKit
import AVFoundation
import PuzzleAnimation

class GameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, AVAudioPlayerDelegate {
	
	let savedDefaults = NSUserDefaults.standardUserDefaults()
	
    var collectionView: UICollectionView!
    var round = 0
    var highscore = 0
    var lives = 5
    var randomColor = UIColor()
    var currentDimension: Int!
    var randomBlockIndex: Int!
    var soundOn = true
    
    var livesLabel = UILabel(frame: CGRectMake(0, 0, 200, 30))
    var notifyLabel = UILabel()
    var audioPlayer = AVAudioPlayer()
    var muteButton = UIButton(type: UIButtonType.Custom) as UIButton
    
    private var backwardAnimation: PuzzleAnimation?
	
	override func viewWillAppear(animated: Bool) {
		loadData()
	}
	
	override func viewWillDisappear(animated: Bool) {
		saveData()
	}

    
    override func viewDidLoad() {
        super.viewDidLoad()
		loadData()
        muteButton.setImage(UIImage(named: "sound"), forState: .Normal)
        
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
		let textFont = "Avenir-BookOblique"
        
        livesLabel.text = "Lives: " + String(lives)
        self.view.addSubview(livesLabel)
        livesLabel.center = CGPointMake(self.view.frame.width/2, (11/16)*self.view.frame.height)
        livesLabel.textAlignment = NSTextAlignment.Center
        livesLabel.backgroundColor = UIColor.silverColor()
        livesLabel.font = UIFont(name: textFont, size: livesLabel.font.pointSize)
		livesLabel.layer.masksToBounds = true
		livesLabel.layer.cornerRadius = 15
        
        let roundLabel = UILabel(frame: CGRectMake(0, 0, 200, 30))
        roundLabel.text = "Round: " + String(round)
        self.view.addSubview(roundLabel)
        roundLabel.center = CGPointMake(self.view.frame.width/2, (12/16)*self.view.frame.height)
        roundLabel.textAlignment = NSTextAlignment.Center
        roundLabel.backgroundColor = UIColor.silverColor()
        roundLabel.font = UIFont(name: textFont, size: roundLabel.font.pointSize)
		roundLabel.layer.masksToBounds = true
		roundLabel.layer.cornerRadius = 15
		
		let highscoreLabel = UILabel(frame: CGRectMake(0, 0, 200, 30))
		highscoreLabel.text = "Highscore: " + String(highscore)
		self.view.addSubview(highscoreLabel)
		highscoreLabel.center = CGPointMake((self.view.frame.width/2), (13/16)*self.view.frame.height)
		highscoreLabel.textAlignment = NSTextAlignment.Center
		highscoreLabel.backgroundColor = UIColor.silverColor()
		highscoreLabel.font = UIFont(name: textFont, size: highscoreLabel.font.pointSize)
		highscoreLabel.layer.masksToBounds = true
		highscoreLabel.layer.cornerRadius = 15
		
        notifyLabel = UILabel(frame: CGRectMake(0, 0, 350, 50))
        self.view.addSubview(notifyLabel)
        notifyLabel.center = CGPointMake(self.view.frame.width/2, (19/32)*self.view.frame.height)
        notifyLabel.textAlignment = NSTextAlignment.Center
        notifyLabel.font = UIFont(name: textFont, size: 20)
        
        if (round < 7) {
            notifyLabel.text = "one of these does not belong"
            if (round == 6) {
                notifyLabel.fadeOut()
            }
        } else if (round % 25 == 0) {
            notifyLabel.alpha = 0.0
            notifyLabel.text = "+1 Life"
            notifyLabel.font = UIFont(name: "Helvetica", size: 30)
            //notifyLabel.fadeIn()
            notifyLabel.moveCenterTo(CGPointMake(self.view.frame.width/2, (11/16)*self.view.frame.height), returnPoint: CGPointMake(self.view.frame.width/2, (10/16)*self.view.frame.height))
        }
        
        muteButton = UIButton(frame: CGRectMake(0, 0, 50, 50))
        muteButton.addTarget(self, action: #selector(muteButtonPressed), forControlEvents: .TouchUpInside)
        self.view.addSubview(muteButton)
        muteButton.center = CGPointMake((2/16)*self.view.frame.width, (15/16)*self.view.frame.height)
        
        if soundOn {
            muteButton.setImage(UIImage(named: "sound"), forState: .Normal)
        } else {
            muteButton.setImage(UIImage(named: "mute"), forState: .Normal)
        }

    }
    
    func gameOverScene() {
        
        notifyLabel.alpha = 0.0
        notifyLabel.text = "Game Over"
        notifyLabel.fadeIn()
        
        let resetButton = UIButton(frame: CGRectMake(0, 0, 200, 40))
        resetButton.setTitle("~NEW GAME~", forState: .Normal)
        resetButton.addTarget(self, action: #selector(resetButtonPressed), forControlEvents: .TouchUpInside)
        resetButton.setTitleColor(UIColor.wetAsphaltColor(), forState: .Normal)
        self.view.addSubview(resetButton)
        resetButton.center = CGPointMake(self.view.frame.width/2, (7/8)*self.view.frame.height)
        resetButton.backgroundColor = UIColor.concreteColor()
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
                    lives += 1
                }
				//pop sound
				self.popSound()
				
				
				
				
				
				
				if (round >= highscore) {
					highscore = round + 1
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
        backwardConfiguration.animationVelocity = 25
        backwardConfiguration.pieceAnimationDelay = defaultBackwardPieceAnimationDelay
        backwardConfiguration.pieceGroupAnimationDelay = defaultBackwardPieceGroupAnimationDelay
        self.backwardAnimation = BackwardPuzzleAnimation(viewToAnimate: self.view, configuration: backwardConfiguration)
        self.backwardAnimation!.start()
    }
    
    func muteButtonPressed (sender: UIButton) {
        soundOn = !soundOn
        if soundOn {
            muteButton.setImage(UIImage(named: "sound"), forState: .Normal)
        } else {
            muteButton.setImage(UIImage(named: "mute"), forState: .Normal)
        }
    }
	
	func saveData() {
		savedDefaults.setObject(highscore, forKey: "highscore")
	}
	
	func loadData() {
		highscore = savedDefaults.integerForKey("highscore")
	}
	
	func popSound() {
		let sess = AVAudioSession.sharedInstance()
		if sess.otherAudioPlaying {
			_ = try? sess.setCategory(AVAudioSessionCategoryAmbient, withOptions: [])
			_ = try? sess.setActive(true, withOptions: [])
		}
		let popSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("PopSoundEffect", ofType: "mp3")!)
		do{
			audioPlayer = try AVAudioPlayer(contentsOfURL:popSound)
			audioPlayer.prepareToPlay()
			audioPlayer.delegate = self
			if soundOn {
				audioPlayer.play()
			}
		} catch {
			//print("Error getting the audio file")
		}

	}
	

}

