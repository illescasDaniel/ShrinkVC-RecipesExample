//
//  APIClient.swift
//  ProjectTemplate
//
//  Created by Daniel Illescas Romero on 10/03/2019.
//  Copyright © 2019 Daniel Illescas Romero. All rights reserved.
//

import Foundation

enum APIClientError: Error {
	case invalidData
}

public protocol APIClient {
	associatedtype APIConfigType: APIConfiguration
	static func request<RequestType: Decodable>(_ config: APIConfigType) -> Future<RequestType>
}

public extension APIClient {
	static func request<RequestType: Decodable>(_ config: APIConfigType) -> Future<RequestType> {
		return Future { fulfill, reject in
			
			var urlRequest_: URLRequest?
			do {
				urlRequest_ = try config.asURLRequest()
			} catch {
				reject(error)
			}
			
			guard let urlRequest = urlRequest_ else { return }
			
			let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
				
				guard let data = data else {
					reject(error ?? APIClientError.invalidData)
					return
				}
				
				do {
					let decodedObject = try JSONDecoder().decode(RequestType.self, from: data)
					fulfill(decodedObject)
				} catch {
					reject(error)
				}
				
				
			}
			task.resume()
			
			// If using Alamofire 5
			/*AF.request(config).responseDecodable { (response: DataResponse<RequestType>) in
				switch response.result {
				case .success(let response_):
					fulfill(response_)
				case .failure(let error):
					reject(error)
				}
			}*/
		}
	}
}
