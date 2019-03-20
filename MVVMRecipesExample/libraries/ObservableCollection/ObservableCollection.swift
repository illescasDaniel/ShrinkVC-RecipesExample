//
//  ObservableCollection.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

public enum ObserverAction {
	case append
	case remove
	case removeAll
	case insert
	case move
	case update
}
public protocol ObservableCollection {
	
	associatedtype CollectionType: Collection
	
	typealias ObserverHandler = (_ element: CollectionType.Element, _ indices: [CollectionType.Index]) -> Void
	
	var rawElements: CollectionType { get }
	var observers: [ObserverAction: ObserverHandler] { get }
	
	init(_ elements: CollectionType, observers: [ObserverAction: ObserverHandler] )
	
	func append(_ elements: CollectionType.Element...) -> Bool
	func remove(at index: CollectionType.Index) -> Bool
	func removeAll(keepingCapacity: Bool) -> Bool
	func insert(_ elements: CollectionType.Element..., at index: CollectionType.Index) -> Bool
	func move(from firstIndex: CollectionType.Index, to lastIndex: CollectionType.Index) -> Bool
	func update(elementAt index: CollectionType.Index, _ foundElementHandler: (CollectionType.Element) -> CollectionType.Element) -> Bool
}

// Some convenient methods
public extension ObservableCollection {
	public var count: Int {
		return self.rawElements.count
	}
	public var isEmpty: Bool {
		return self.rawElements.isEmpty
	}
	public subscript(safe index: CollectionType.Index) -> CollectionType.Element? {
		return self.rawElements.indices.contains(index) ? self.rawElements[index] : nil
	}
}

public extension ObservableCollection where CollectionType: CustomStringConvertible {
	public var description: String {
		return self.rawElements.description
	}
}
