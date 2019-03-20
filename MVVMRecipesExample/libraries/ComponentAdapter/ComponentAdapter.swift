//
//  ComponentAdapter.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import UIKit

public protocol ComponentAdapter {
	associatedtype Component: UIView
	associatedtype Elements: Collection
}
