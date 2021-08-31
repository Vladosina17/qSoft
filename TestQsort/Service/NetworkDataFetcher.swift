//
//  NetworkDataFetcher.swift
//  TestQsort
//
//  Created by Влад Барченков on 17.08.2021.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol DataFetcher {
//    func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping (Result<T?, Error>) -> Void)
    func fetchAuthURL(urlString: String, completion: @escaping (_ url: URL?) -> Void)
    
    func fetchMappableJSONData<T: Mappable>(urlString: String, response: @escaping (Result<T?, Error>) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    var networking: Networking
    
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    func fetchMappableJSONData<T: Mappable>(urlString: String, response: @escaping (Result<T?, Error>) -> Void) {
        networking.request(urlString: urlString) { data, error in
            if let error = error {
                response(.failure(error))
            }
            let decode = self.decodeObjectMapper(type: T.self, from: data)
            response(.success(decode))
        }
    }
    
    func fetchAuthURL(urlString: String, completion: @escaping (URL?) -> Void) {
        networking.requestWithResponse(urlString: urlString) { response in
            if let response = response {
                completion(response.url)
            }
        }
    }
    
    func fetchUserToken<T: Mappable>(urlString: String, headers: [String: String], postData: Data, response: @escaping (Result<T?, Error>) -> Void ) {
        networking.requestPost(urlString: urlString, headers: headers, postData: postData) { data, error in
            if let error = error {
                response(.failure(error))
            }
            let decode = self.decodeObjectMapper(type: T.self, from: data)
            response(.success(decode))
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
    
    //новое
    func decodeObjectMapper<T: Mappable>(type: T.Type, from: Data?) -> T? {
        guard let data = from else { return nil }
        let json = JSON(data)
        if let jsonString = json.rawString() {
            let model = T(JSONString: jsonString)
            return model
        } else {
            return nil
        }
    }
    
}
