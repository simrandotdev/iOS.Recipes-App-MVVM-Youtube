//
//  NetworkingManager.swift
//  RecipesAppMVVMPractice
//
//  Created by jc on 2021-06-20.
//

import Foundation

typealias NetworkRequestCompletionHander<T> = ((Result<T, APIError>) -> Void)

class NetworkingManager {
    public static let shared = NetworkingManager()
    
    private init() {}
    
    func GET<T: Codable>(type: T.Type,
                         urlString: String,
                         queryParameters: [String:String]? = nil,
                         completion: @escaping NetworkRequestCompletionHander<T>) throws {
        let urlRequest = try buildURLRequest(urlString: urlString,
                                             httpMethod: .GET,
                                             queryParameters: queryParameters)
        makeRequest(type: type, urlRequest: urlRequest, completion: completion)
    }
}


extension NetworkingManager {
    private func makeRequest<T: Codable>(type: T.Type,
                                         urlRequest: URLRequest,
                                         completion: @escaping NetworkRequestCompletionHander<T>) {
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, httpResponse, error in
            guard error == nil,
                  let response = httpResponse as? HTTPURLResponse,
                  let data = data else {
                self?.handError(type: type, error: error, completion: completion)
                return
            }
            self?.handleResponse(type: type, response: response, data: data, completion: completion)
        }.resume()
    }
    
    
    private func handleResponse<T: Codable>(type: T.Type,
                                            response: HTTPURLResponse,
                                            data: Data,
                                            completion: @escaping NetworkRequestCompletionHander<T>) {
        if response.statusCode == 200 {
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(type, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("\(#function) in \(#file) failed to decode with error: \(String(describing: error.localizedDescription))")
                completion(.failure(.failedToDecode))
            }
        } else {
            completion(.failure(.somethingWentWrong))
        }
    }
    
    private func handError<T: Codable>(type: T.Type,
                                       error: Error?,
                                       completion: @escaping NetworkRequestCompletionHander<T>) {
        print("\(#function) in \(#file) failed with error: \(String(describing: error?.localizedDescription))")
        completion(.failure(.somethingWentWrong))
    }
    
    
    private func buildURLRequest(urlString: String,
                                 httpMethod: HttpMethod = .GET,
                                 queryParameters: [String:String]? = nil) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        guard let urlWithQueryParameters =
                buildURLWithQueryParameters(url: url, queryParameters: queryParameters) else {
            throw APIError.badRequest
        }
        
        var urlRequest = URLRequest(url: urlWithQueryParameters, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
    
    private func buildURLWithQueryParameters(url: URL,
                                             queryParameters: [String: String]? = nil) -> URL? {
        var queryItems = [URLQueryItem]()
        for (key, value) in queryParameters ?? [:] {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = queryItems
        return urlComponent?.url
    }
}


enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

enum APIError: Error {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL, please check you are calling a valid and correct endpoint."
        case .failedToDecode:
            return "Failed to convert API response."
        case .somethingWentWrong:
            return "Something went wrong. please try again."
        case .badRequest:
            return "Could not process the request, something was missing."
        }
    }
    
    
    case invalidURL
    case failedToDecode
    
    // Http Request Errors
    case somethingWentWrong
    case badRequest
}
