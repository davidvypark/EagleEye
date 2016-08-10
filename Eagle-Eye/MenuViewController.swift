//
//  MenuViewController.swift
//  Eagle-Eye
//
//  Created by David Park on 8/7/16.
//  Copyright © 2016 David Park. All rights reserved.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {
	
	var marathonButton = UIButton()
	var singleColorButton = UIButton()
	var vizzyLabel = UILabel()
	var backdropImage = UIImageView()
	var patternImageView = UIImageView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.setNavigationBarHidden(true, animated: false)
		view.backgroundColor = UIColor.cloudsColor()
		
		setupScene()
	}
	
	func setupScene() {
		
		view.addSubview(backdropImage)
		backdropImage.snp_makeConstraints { (make) in
			make.width.equalTo(view.snp_width)
			make.height.equalTo(view.snp_height).dividedBy(2)
			make.top.equalTo(view.snp_top)
			make.left.equalTo(view.snp_left)
		}
		backdropImage.image = UIImage(named: "rainbow")
		backdropImage.contentMode = UIViewContentMode.ScaleAspectFill
		
		view.addSubview(patternImageView)
		patternImageView.snp_makeConstraints { (make) in
			make.top.equalTo(backdropImage.snp_bottom)
			make.left.equalTo(view.snp_left)
			make.bottom.equalTo(view.snp_bottom)
		}
		patternImageView.image = UIImage(named: "pattern")
		patternImageView.contentMode = UIViewContentMode.ScaleAspectFill
		
		
		view.addSubview(vizzyLabel)
		vizzyLabel.snp_makeConstraints { (make) in
			make.width.equalTo(view.snp_width).dividedBy(2)
			make.center.equalTo(backdropImage.snp_center)
			make.height.equalTo(view.snp_height).dividedBy(10)
		}
		vizzyLabel.text = "Eagle Eyed"
		vizzyLabel.font = UIFont(name: "Avenir-HeavyOblique", size: 40)
		vizzyLabel.textColor = UIColor.whiteColor()
		vizzyLabel.textAlignment = .Center
		vizzyLabel.backgroundColor = UIColor.clearColor()
		vizzyLabel.layer.masksToBounds = true
		vizzyLabel.layer.cornerRadius = self.view.frame.height/40
		vizzyLabel.adjustsFontSizeToFitWidth = true
		
		view.addSubview(marathonButton)
		marathonButton.snp_makeConstraints { (make) in
			make.width.equalTo(view.snp_width).dividedBy(1.5)
			make.height.equalTo(view.snp_height).dividedBy(10)
			make.centerX.equalTo(view.snp_centerX)
			make.centerY.equalTo(view.snp_centerY).multipliedBy(1.3)
		}
		marathonButton.setTitle("Challenge Mode", forState: .Normal)
		marathonButton.titleLabel?.font = UIFont(name: "Avenir-MediumOblique", size: 20)
		marathonButton.titleLabel?.textAlignment = .Center
		marathonButton.backgroundColor = UIColor.pastelDarkBlue()
		marathonButton.layer.masksToBounds = true
		marathonButton.layer.cornerRadius = view.frame.height/20
		marathonButton.addTarget(self, action: #selector(challengeModeButtonPressed), forControlEvents: .TouchUpInside)
		
		view.addSubview(singleColorButton)
		singleColorButton.snp_makeConstraints { (make) in
			make.width.equalTo(marathonButton.snp_width)
			make.height.equalTo(marathonButton.snp_height)
			make.centerX.equalTo(marathonButton.snp_centerX)
			make.centerY.equalTo(view.snp_centerY).multipliedBy(1.55)
		}
		singleColorButton.setTitle("Single Color", forState: .Normal)
		singleColorButton.titleLabel?.font = UIFont(name: "Avenir-MediumOblique", size: 20)
		singleColorButton.titleLabel?.textAlignment = .Center
		singleColorButton.backgroundColor = UIColor.pastelRed()
		singleColorButton.layer.masksToBounds = true
		singleColorButton.layer.cornerRadius = view.frame.height/20
		singleColorButton.addTarget(self, action: #selector(singleColorButtonPressed), forControlEvents: .TouchUpInside)
		
	}
	
	func challengeModeButtonPressed() {
		//need a transition here
		
		let gameVC = GameViewController()
		gameVC.isRandom = true
		
		UIView.animateWithDuration(0.75, animations: { () -> Void in
			UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
			self.navigationController!.pushViewController(gameVC, animated: false)
			UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.navigationController!.view!, cache: false)
		})

	}
	
	func singleColorButtonPressed() {
		//need a transition here
		UIView.animateWithDuration(0.75, animations: { () -> Void in
			UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
			self.navigationController!.pushViewController(PickColorViewController(), animated: false)
			UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.navigationController!.view!, cache: false)
		})
		
	}

}
