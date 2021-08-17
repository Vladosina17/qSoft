//
//  NetworkService.swift
//  TestQsort
//
//  Created by Влад Барченков on 17.08.2021.
//

import Foundation

protocol Networking {
    func request(urlString: String,completion: @escaping (Data?, Error?) -> Void)
    func requestPost(urlString: String, headers: [String : String], postData: Data, completion: @escaping (Data?, Error?) -> Void)
    func requestWithResponse(urlString: String, completion: @escaping (URLResponse?) -> Void)
}

class NetworkService: Networking {

    //MARK: - request
    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {  return }
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func requestWithResponse(urlString: String, completion: @escaping (URLResponse?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = createDataTaskWithResponse(from: request, completion: completion)
        task.resume()
    }
    
    func requestPost(urlString: String, headers: [String : String], postData: Data, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    //MARK: - Task
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    private func createDataTaskWithResponse(from request: URLRequest, completion: @escaping (URLResponse?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
}
