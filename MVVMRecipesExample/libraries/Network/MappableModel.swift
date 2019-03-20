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
	static func from(_ endpointModel: Future<EndpointModel>) -> Future<Self>
	static func map(from endpointModel: EndpointModel) -> Self
}

public protocol MappableArrayModel: Decodable {
	associatedtype EndpointModel: Decodable
	static func from(_ endpointModel: Future<EndpointModel>) -> Future<[Self]>
	static func map(from endpointModel: EndpointModel) -> [Self]
}

public extension MappableModel {
	public static func from(_ endpointModel: Future<EndpointModel>) -> Future<Self> {
		return endpointModel.map(Self.map)
	}
}

public extension MappableArrayModel {
	public static func from(_ endpointModel: Future<EndpointModel>) -> Future<[Self]> {
		return endpointModel.map(Self.map)
	}
}

