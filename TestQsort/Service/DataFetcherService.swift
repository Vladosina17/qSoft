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
    
    
    //with objectMapper
    func getMedia2(mediaId: String, completion: @escaping (InstagramMedia2?, Error?) -> Void) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String else { return }
        let urlString = Enpoints.media(mediaId: mediaId, token: token).path
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let data = data else { return }
                let json = String(decoding: data, as: UTF8.self)
                let media = InstagramMedia2(JSONString: json)
                completion(media, nil)
            }
        }
        task.resume()
    }
    
    
    //with Alomofire
    func getMedia3(mediaId: String, completion: @escaping (InstagramMedia2?, Error?) -> Void) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String else { return }
        let urlString = Enpoints.media(mediaId: mediaId, token: token).path

        AF.request(urlString).validate().response { response in
            switch response.result {
            case .success(let value):
                guard let value = value else { return }
                let json = JSON(value)
                let media = InstagramMedia2(JSONString: json.rawString()!)
                completion(media, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Validate token
    func validate(completion: @escaping (ErrorsModel?)-> Void ) {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["token"] as? String, let userId = Locksmith.loadDataForUserAccount(userAccount: "Auth")?["user_id"] as? Int else { return }
        
        guard  let urlString = URL(string: Enpoints.user(id: userId, token: token).path) else { return }
        let request = URLRequest(url: urlString)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            guard let data = data else { return }
            if httpResponse?.statusCode == 400 {
                do {
                    let object = try JSONDecoder().decode(ErrorsModel.self, from: data)
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
