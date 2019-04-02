//
//  ObservableCollection.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

public typealias Callback<T> = (T) -> Void

public enum ObserverAction<Element, Index: Comparable> {
	case append(Callback<(newElements: [Element], firstIndex: Index)>)
	case remove(Callback<(removedElement: Element, elementIndex: Index)>)
	case removeAll(Callback<(firstElement: Element, lastElement: Element, indices: Range<Index>)>)
	case insert(Callback<(insertedElements: [Element], indices: Range<Index>)>)
	case move(Callback<(source: (element: Element, index: Index), destinationIndex: Index)>)
	case update(Callback<(updatedElement: Element, index: Index)>)
}

public protocol ObservableCollection {
	
	associatedtype CollectionType: Collection
	
	typealias ObserverHandler = (_ element: CollectionType.Element, _ indices: [CollectionType.Index]) -> Void
	
	var rawElements: CollectionType { get }
	var observers: [ObserverAction<CollectionType.Element, CollectionType.Index>] { get }
	
	init(_ elements: CollectionType, observers: [ObserverAction<CollectionType.Element, CollectionType.Index>])
	
	func append(_ elements: CollectionType.Element...) -> Bool
	func remove(at index: CollectionType.Index) -> Bool
	func removeAll(keepingCapacity: Bool) -> Bool
	func insert(_ elements: CollectionType.Element..., at index: CollectionType.Index) -> Bool
	func move(from firstIndex: CollectionType.Index, to lastIndex: CollectionType.Index) -> Bool
	func update(elementAt index: CollectionType.Index, _ foundElementHandler: (CollectionType.Element) -> CollectionType.Element) -> Bool
}

// Some convenient methods
public extension ObservableCollection {
	var count: Int {
		return self.rawElements.count
	}
	var isEmpty: Bool {
		return self.rawElements.isEmpty
	}
	subscript(safe index: CollectionType.Index) -> CollectionType.Element? {
		return self.rawElements.indices.contains(index) ? self.rawElements[index] : nil
	}
}

public extension ObservableCollection where CollectionType: CustomStringConvertible {
	var description: String {
		return self.rawElements.description
	}
}
