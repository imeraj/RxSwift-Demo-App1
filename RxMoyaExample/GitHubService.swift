//
//  GitHubService.swift
//  RxMoyaExample
//
//  Created by iMeraj-MacbookPro on 9/6/16.
//  Copyright © 2016 Sekai Lab BD. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

enum GitHubService {
    case UserProfile(username: String)
    case Repos(username: String)
    case Repo(fullName: String)
    case Issues(repositoryFullName: String)
}

extension GitHubService: TargetType {
    var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }
    
    var path: String {
        switch self {
        case .Repos(let name):
            return "/users/\(name.URLEscapedString)/repos"
        case .UserProfile(let name):
            return "/users/\(name.URLEscapedString)"
        case .Repo(let name):
            return "/repos/\(name)"
        case .Issues(let repositoryName):
            return "/repos/\(repositoryName)/issues"
        }
    }
    
    var method: Moya.Method {
        return .GET
    }
    
    var parameters: [String: AnyObject]? {
        return nil
    }
    
    var sampleData: NSData {
        switch self {
        case .Repos(_):
            return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .UserProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .Repo(_):
            return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .Issues(_):
            return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        // Optional
        return nil
    }
}