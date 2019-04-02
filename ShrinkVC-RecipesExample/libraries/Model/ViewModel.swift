//
//  ViewModel.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

public protocol ViewModel {
	associatedtype Model
	var model: Model { get }
	var emptyState: Bool { get set }
	init(model: Model)
	static func map(from model: Model) -> Self
	static func map(from model: [Model]) -> [Self]
}

public extension ViewModel {
	static func map(from model: Model) -> Self {
		return Self(model: model)
	}
	static func map(from model: [Model]) -> [Self] {
		return model.map { Self(model: $0) }
	}
}

extension ViewModel where Model: MockableModel {
	var mock: Model {
		return Model.mock
	}
}
