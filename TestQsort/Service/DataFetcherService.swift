//
//  DataFetcherService.swift
//  TestQsort
//
//  Created by Влад Барченков on 17.08.2021.
//

import Foundation
import Locksmith
import ObjectMapper
import Alamofire
import SwiftyJSON

class DataFetcherService {
    
    // MARK: - Constants
    static let shared = DataFetcherService()
    
    var networkDataFetcher = NetworkDataFetcher()
    
    init() {}
    
    // MARK: - Networking
    func getInstagramUser(completion: @escaping (Result<InstagramUser?, Error>) -> Void) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String, let userId = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["user_id"] as? Int else { return }
        let urlString = Endpoints.user(id: userId, token: token).path
        networkDataFetcher.fetchMappableJSONData(urlString: urlString, response: completion)
    }
    
    func getMediaData(completion: @escaping (Result<Feed?, Error>) -> Void) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String else { return }
        let urlString = Endpoints.mediaData(token: token).path
        networkDataFetcher.fetchMappableJSONData(urlString: urlString, response: completion)
    }
    
    func getMedia(mediaId: String, completion: @escaping (Result<InstagramMedia?, Error>) -> Void) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String else { return }
        let urlString = Endpoints.media(mediaId: mediaId, token: token).path
        networkDataFetcher.fetchMappableJSONData(urlString: urlString, response: completion)
    }
    
    func getPoginationMediaData(next: String?, completion: @escaping (Result<Feed?, Error>) -> Void) {
        guard let urlString = next else {return}
        networkDataFetcher.fetchMappableJSONData(urlString: urlString, response: completion)
    }
    
    // MARK: - Validate token
    func validate(completion: @escaping (ErrorsModel?)-> Void ) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String, let userId = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["user_id"] as? Int else { return }
        
        guard  let urlString = URL(string: Endpoints.user(id: userId, token: token).path) else { return }
        let request = URLRequest(url: urlString)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            guard let data = data else { return }
            if httpResponse?.statusCode == 400 {
                    let json = JSON(data)
                    let object = ErrorsModel(JSONString: json.rawString()!)
                    completion(object)
                 
            } else {
                    completion(nil)
            }
        }
        task.resume()
    }
}
