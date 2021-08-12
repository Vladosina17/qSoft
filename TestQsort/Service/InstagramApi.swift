//
//  InstagramApi.swift
//  TestQsort
//
//  Created by Влад Барченков on 10.08.2021.
//

import Foundation

class InstagramApi {
    
    static let shared = InstagramApi()
    
    private let instagramAppID = "530444611372217"
    private let redirectURIURLEncoded = "https%3A%2F%2Fwww.google.com%2F"
    private let redirectURI = "https://www.google.com/"
    private let app_secret = "cfa4b0dd56643e4d3e2dac2bf922b181"
    private let boundary = "boundary=\(NSUUID().uuidString)"
    
    private enum BaseURL: String {
        case displayApi = "https://api.instagram.com/"
        case graphApi = "https://graph.instagram.com/"
    }
    
    private enum Method: String {
        case authorize = "oauth/authorize"
        case access_token = "oauth/access_token"
    }
    
    private init () {}
    
    func authorizeApp(completion: @escaping (_ url: URL?) -> Void ) {
        let urlString = "\(BaseURL.displayApi.rawValue)\(Method.authorize.rawValue)?app_id=\(instagramAppID)&redirect_uri=\(redirectURI)&scope=user_profile,user_media&response_type=code"
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
                completion(response.url)
            }
        })
        task.resume()
    }
    
    //MARK: - Token
    private func getTokenFromCallbackURL(request: URLRequest) -> String? {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.starts(with: "\(redirectURI)?code=") {
            
            print("Response uri:",requestURLString)
            if let range = requestURLString.range(of: "\(redirectURI)?code=") {
                return String(requestURLString[range.upperBound...].dropLast(2))
            }
        }
        return nil
    }
    
    private func getFormBody(_ parameters: [[String : String]], _ boundary: String) -> Data {
        var body = ""
        let error: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                var fileContent: String = ""
                do { fileContent = try String(contentsOfFile: filename, encoding: String.Encoding.utf8)}
                catch {
                    print(error)
                }
                if (error != nil) {
                    print(error!)
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        return body.data(using: .utf8)!
    }
    
    func getTestUserIDAndToken(request: URLRequest, completion: @escaping (InstagramTestUser) -> Void){
        guard let authToken = getTokenFromCallbackURL(request: request) else {
            return
        }
        let headers = [
            "content-type": "multipart/form-data; boundary=\(boundary)"
        ]
        let parameters = [
            [
                "name": "client_id",
                "value": instagramAppID
            ],
            [
                "name": "client_secret",
                "value": app_secret
            ],
            [
                "name": "grant_type",
                "value": "authorization_code"
            ],
            [
                "name": "redirect_uri",
                "value": redirectURI
            ],
            [
                "name": "code",
                "value": authToken
            ]
        ]
        var request = URLRequest(url: URL(string: BaseURL.displayApi.rawValue + Method.access_token.rawValue)!)
        let postData = getFormBody(parameters, boundary)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                do {
                    let jsonData = try JSONDecoder().decode(InstagramTestUser.self, from: data!)
                    print(jsonData)
                    completion(jsonData)
                } catch let error as NSError {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
    
    
    //MARK:- User
    
    func getInstagramUser(completion: @escaping (InstagramUser) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return  }
        let userId = UserDefaults.standard.integer(forKey: "user_id")
        
        let urlString = "\(BaseURL.graphApi.rawValue)\(userId)?fields=id,username&access_token=\(token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
            }
            do {
                let jsonData = try JSONDecoder().decode(InstagramUser.self, from: data!)
                completion(jsonData)
            } catch let error as NSError {
                print(error)
            }
        })
        dataTask.resume()
    }
    
    
    //MARK:- Media
    
    func getMediaData(completion: @escaping (Feed) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return  }
        
        let urlString = "\(BaseURL.graphApi.rawValue)me/media?fields=id,caption,media_type&access_token=\(token)&limit=5"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response {
                print(response)
            }
            do {
                let jsonData = try JSONDecoder().decode(Feed.self, from: data!)
                print(jsonData)
                completion(jsonData)
            } catch let error as NSError {
                print(error)
            }
        })
        task.resume()
    }
    
    func getMedia(mediaId: String, completion: @escaping (InstagramMedia) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return  }
        
        let urlString = "\(BaseURL.graphApi.rawValue + mediaId)?fields=id,media_type,media_url,username,timestamp,caption&access_token=\(token)"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            
            do {
                let jsonData = try JSONDecoder().decode(InstagramMedia.self, from: data!)
                print(jsonData)
                completion(jsonData)
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }
}
