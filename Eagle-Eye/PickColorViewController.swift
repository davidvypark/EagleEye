//
//  PickColorViewController.swift
//  Eagle-Eye
//
//  Created by David Park on 8/7/16.
//  Copyright © 2016 David Park. All rights reserved.
//

import UIKit

class PickColorViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	
	var pickAColorLabel = UILabel()
	var collectionView: UICollectionView!
	var backButton = UIButton()
	var colorPicked = UIColor()
	
	let customColorArray = [UIColor.pomergranateColor(), UIColor.alizarinColor(), UIColor.pumpkinColor(), UIColor.carrotColor(), UIColor.sunflowerColor(), UIColor.midnightBlueColor(), UIColor.wetAsphaltColor(), UIColor.wisteriaColor(), UIColor.amethystColor(), UIColor.belizeHoleColor(), UIColor.peterRiverColor(), UIColor.nephritisColor(), UIColor.emeraldColor(), UIColor.greenSeaColor(), UIColor.turquoiseColor()]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.setNavigationBarHidden(true, animated: false)
		
		view.backgroundColor = UIColor.cloudsColor()
		setupGrid()
		setupScene()
	}
	
	func setupScene() {
		view.addSubview(pickAColorLabel)
		pickAColorLabel.snp_makeConstraints { (make) in
			make.height.equalTo(view.snp_height).dividedBy(10)
			make.width.equalTo(view.snp_width).dividedBy(2)
			make.centerX.equalTo(view.snp_centerX)
			make.centerY.equalTo(view.snp_centerY).dividedBy(4)
		}
		pickAColorLabel.text = "pick a color"
		pickAColorLabel.font = UIFont(name: "Avenir-BookOblique", size: 30)
		pickAColorLabel.textAlignment = .Center
		
		view.addSubview(backButton)
		backButton.snp_makeConstraints { (make) in
			make.height.equalTo(view.snp_height).dividedBy(10)
			make.width.equalTo(view.snp_width).dividedBy(2)
			make.centerX.equalTo(view.snp_centerX)
			make.centerY.equalTo(view.snp_centerY).multipliedBy(1.5)
		}
		backButton.setTitle("< Return to Menu", forState: .Normal)
		backButton.layer.cornerRadius = view.frame.height/20
		print(backButton.frame.height)
		backButton.backgroundColor = UIColor.pastelDarkBlue()
		backButton.addTarget(self, action: #selector(backButtonPressed), forControlEvents: .TouchUpInside)
		
	}
	
	func setupGrid() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 150, left: 20, bottom: 30, right: 20)
		
		//item size
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 5
		let blockDemension = ((self.view.frame.width - 60) / 5)
		layout.itemSize = CGSize(width: blockDemension, height: blockDemension)
		
		collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
		collectionView.backgroundColor = UIColor.cloudsColor()
		
		self.view.addSubview(collectionView)
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return customColorArray.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath)
		
		cell.backgroundColor = customColorArray[indexPath.row]
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		colorPicked = customColorArray[indexPath.row]
		
		let gameVC = GameViewController()
		gameVC.gameColor = colorPicked
		gameVC.isRandom = false
		
		UIView.animateWithDuration(0.75, animations: { () -> Void in
			UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
			self.navigationController!.pushViewController(gameVC, animated: false)
			UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.navigationController!.view!, cache: false)
		})
		
	}
	
	func backButtonPressed() {
		navigationController?.popViewControllerAnimated(true)
		
		UIView.animateWithDuration(0.75, animations: { () -> Void in
			UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
			UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft , forView: self.navigationController!.view!, cache: false)
		})
	}


}
