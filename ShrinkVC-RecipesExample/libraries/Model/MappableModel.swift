//
//  MappableModel.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

public protocol MappableModel: Decodable {
	associatedtype EndpointModel: Decodable
	static func map(from endpointModel: EndpointModel) -> Self
}

public protocol MappableArrayModel: Decodable {
	associatedtype EndpointModel: Decodable
	static func map(from endpointModel: EndpointModel) -> [Self]
}
