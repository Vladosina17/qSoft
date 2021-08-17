//
//  AuthFetcherService.swift
//  TestQsort
//
//  Created by Влад Барченков on 17.08.2021.
//

import Foundation

class AuthFetcherService {
    
    static let shared = AuthFetcherService()
    
    var networkDataFetcher = NetworkDataFetcher()
    private let boundary = "boundary=\(NSUUID().uuidString)"
    
    init() {}
    
    //MARK: Auth
    func authorizeApp(completion: @escaping (_ url: URL?) -> Void) {
        let urlString = Enpoints.authorizeApp.path
        networkDataFetcher.fetchAuthURL(urlString: urlString, completion: completion)
    }
    
    func getTestUserIDAndToken(request: URLRequest, completion: @escaping (Result<InstagramTestUser?, Error>) -> Void) {
        
        guard let authToken = getTokenFromCallbackURL(request: request) else {
            return
        }
        
        let headers = [
            "content-type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        let parameters = [
            [
                "name": "client_id",
                "value": AuthParam.instagramAppID.rawValue
            ],
            [
                "name": "client_secret",
                "value": AuthParam.app_secret.rawValue
            ],
            [
                "name": "grant_type",
                "value": "authorization_code"
            ],
            [
                "name": "redirect_uri",
                "value": AuthParam.redirectURI.rawValue
            ],
            [
                "name": "code",
                "value": authToken
            ]
        ]
        
        let urlString = Enpoints.token.path
        let postData = getFormBody(parameters, boundary)
        networkDataFetcher.fetchUserToken(urlString: urlString, headers: headers, postData: postData, response: completion)
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
                do {
                    fileContent = try String(contentsOfFile: filename, encoding: String.Encoding.utf8)
                } catch {
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
    
    private func getTokenFromCallbackURL(request: URLRequest) -> String? {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.starts(with: "\(AuthParam.redirectURI.rawValue)?code=") {
            if let range = requestURLString.range(of: "\(AuthParam.redirectURI.rawValue)?code=") {
                return String(requestURLString[range.upperBound...].dropLast(2))
            }
        }
        return nil
    }
}
