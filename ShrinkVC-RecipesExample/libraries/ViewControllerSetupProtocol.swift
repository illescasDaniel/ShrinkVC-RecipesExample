//
//  ViewControllerSetupProtocol.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

public protocol ViewControllerSetupProtocol {
	func setupUI()
	func setupController()
	func setupLocalization()
}
