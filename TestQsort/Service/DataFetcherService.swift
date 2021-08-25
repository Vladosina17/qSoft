//
//  DataFetcherService.swift
//  TestQsort
//
//  Created by Влад Барченков on 17.08.2021.
//

import Foundation
import Locksmith

class DataFetcherService {
    
    static let shared = DataFetcherService()
    var networkDataFetcher = NetworkDataFetcher()
    
    init() {}
    
    func getInstagramUser(completion: @escaping (Result<InstagramUser?, Error>) -> Void) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String, let userId = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["user_id"] as? Int else { return }
        let urlString = Enpoints.user(id: userId, token: token).path
        networkDataFetcher.fetchGenericJSONData(urlString: urlString, response: completion)
    }
    
    func getMediaData(completion: @escaping (Result<Feed?, Error>) -> Void) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String else { return }
        let urlString = Enpoints.mediaData(token: token).path
        networkDataFetcher.fetchGenericJSONData(urlString: urlString, response: completion)
    }
    
    func getMedia(mediaId: String, completion: @escaping (Result<InstagramMedia?, Error>) -> Void) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String else { return }
        let urlString = Enpoints.media(mediaId: mediaId, token: token).path
        networkDataFetcher.fetchGenericJSONData(urlString: urlString, response: completion)
    }
    
    func getPoginationMediaData(next: String?, completion: @escaping (Result<Feed?, Error>) -> Void) {
        guard let urlString = next else {return}
        networkDataFetcher.fetchGenericJSONData(urlString: urlString, response: completion)
    }
    
    
    func validate(completion: @escaping (ErrorModel?)-> Void ) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String, let userId = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["user_id"] as? Int else { return }
        
        guard  let urlString = URL(string: Enpoints.user(id: userId, token: token).path) else { return }
        let request = URLRequest(url: urlString)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            guard let data = data else { return }
            if httpResponse?.statusCode == 400 {
                do {
                    let object = try JSONDecoder().decode(ErrorModel.self, from: data)
                    completion(object)
                } catch let jsonError {
                   print(jsonError)
                }
            } else {
                    completion(nil)
            }
        }
        task.resume()
    }
}
