//
//  Item.swift
//  MilestoneProject4-6
//
//  Created by Adnann Muratovic on 06/01/2021.
//  Copyright © 2021 Adnann Muratovic. All rights reserved.
//

import Foundation

class Item: NSObject, Codable {
	 var item = [String]()
	
	init(item: [String]) {
		self.item = item
	}
}
