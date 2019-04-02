//
//  Future.swift
//  MVVMExample
//
//  Created by Daniel Illescas Romero on 20/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import class Foundation.NSError
import class Dispatch.DispatchQueue
import class Dispatch.DispatchGroup

public typealias Future<T> = Futures.Future<T>

public class Futures {
	
	private init() {}
	
	public class Future<T> {
		
		public typealias Callback<C> = (C) -> Void
		
		private var callback: (_ fulfill: @escaping Callback<T>, _ reject: @escaping Callback<Error>) -> Void
		
		public init(_ callback: @escaping (_ fulfill: @escaping Callback<T>, _ reject: @escaping Callback<Error>) -> Void) {
			self.callback = callback
		}
		
		@discardableResult
		public func then(_ callback: @escaping Callback<T>) -> Future {
			DispatchQueue.global().async {
				self.callback(callback, { _ in })
			}
			return self
		}
		
		public func `catch`(_ callback: @escaping Callback<Error>) {
			DispatchQueue.global().async {
				self.callback({_ in }, callback)
			}
		}
		
		public func map<F>(_ mapper: @escaping (T) -> F) -> Future<F> {
			return Future<F> { fulfill, reject in
				self.then { model in
					fulfill(mapper(model))
					}.catch { error in
						reject(error)
				}
			}
		}
	}
	
	public static func await<T>(_ future: Future<T>) throws -> T {
		
		var value: T? = nil
		var error: Error? = nil
		
		let group = DispatchGroup()
		group.enter()
		future.then { promisedValue in
			value = promisedValue
			group.leave()
			}.catch { promisedError in
				error = promisedError
				group.leave()
		}
		group.wait()
		
		if let error = error {
			throw error
		} else if let value = value {
			return value
		}
		
		throw NSError()
	}
}

