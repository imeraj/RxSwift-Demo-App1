//
//  UserInfoModel.swift
//  RxMoyaExample
//
//  Created by iMeraj-MacbookPro on 9/6/16.
//  Copyright © 2016 Sekai Lab BD. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct UserInfoModel {
    let provider: RxMoyaProvider<GitHubService>
    let userName: Observable<String>
    
    func getUserProfile() -> Observable<UserProfile?> {
        return userName
            .observeOn(MainScheduler.instance)
            .flatMapLatest ({ name -> Observable<UserProfile?> in
                print("Name: \(name)")
                return self.getUserProfile(name)
                           .catchError({ (error) -> Observable<UserProfile?> in
                                    print("Error caught \(error)")
                                    return Observable.just(nil)
                            })

            })
//            .catchError({ (error) -> Observable<UserProfile?> in
//                    print("Error caught \(error)")
//                    return Observable.just(nil)
//            })
    }
    
    internal func getUserProfile(name: String) -> Observable<UserProfile?> {
        return self.provider
            .request(GitHubService.UserProfile(username: name))
            .debug()
            .mapObjectOptional(UserProfile.self)
    }
}