//
//  Mockabl.swift
//  MVVMRecipesExample
//
//  Created by Daniel Illescas Romero on 01/04/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

public protocol MockableModel {
	static var mock: Self { get }
}
