//
//  HexOffsetEquation.swift
//  Eagle-Eye
//
//  Created by David Park on 7/6/16.
//  Copyright © 2016 David Park. All rights reserved.
//

import Foundation

func hexOffsetValue(round: Int) -> Float {
    
    return 0.2/(Float(round)/8)
}

func generateDimensionsOfGrid(round: Int) -> Int{
    
    return Int(7-(7/(0.3 * Double(round+4))))
}
