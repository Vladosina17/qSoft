//
//  Enpoints.swift
//  TestQsort
//
//  Created by Влад Барченков on 17.08.2021.
//

import Foundation


enum Enpoints {
    case user(id: Int, token: String)
    case mediaData(token: String)
    case media(mediaId: String, token: String)
    case authorizeApp
    case token
    
    var path: String {
        switch self {
        case .user(id: let id, token: let token):
            return "\(BaseUrl.graphApi.rawValue)\(id)?fields=id,username&access_token=\(token)"
            
        case .mediaData(token: let token):
            return "\(BaseUrl.graphApi.rawValue)me/media?fields=id,caption,media_type,media_url,timestamp&access_token=\(token)&limit=8"
            
        case .media(mediaId: let mediaId, token: let token):
            return "\(BaseUrl.graphApi.rawValue + mediaId)?fields=id,media_type,media_url,username,timestamp,caption&access_token=\(token)"
            
        case .authorizeApp:
            return "\(BaseUrl.displayApi.rawValue)\(Methods.authorize.rawValue)?app_id=\(AuthParam.instagramAppID.rawValue)&redirect_uri=\(AuthParam.redirectURI.rawValue)&scope=user_profile,user_media&response_type=code"
        case .token:
            return "\(BaseUrl.displayApi.rawValue + Methods.access_token.rawValue)"
        }
    }
}
