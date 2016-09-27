//
//  IssueTrackerModel.swift
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

struct IssueTrackerModel {

    let provider: RxMoyaProvider<GitHubService>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<[Repository]?> in
                print("Name: \(name)")
                return self.findRepository(name)
                          .catchError({ (error) -> Observable<[Repository]?> in
                                print("Error caught -  \(error)")
                                return Observable.just([])
                          })
            }
            .flatMapLatest { repository -> Observable<[Issue]?> in
                guard let repository = repository!.first else { return Observable.just(nil) }
    
                print("Repository: \(repository.fullName)")
                return self.findIssues(repository)
                          .catchError({ (error) -> Observable<[Issue]?> in
                                print("Error caught -  \(error)")
                                return Observable.just([])
                          })
            }
            .replaceNilWith([])
    }
    
    internal func findIssues(repository: Repository) -> Observable<[Issue]?> {
        return self.provider
                .request(GitHubService.Issues(repositoryFullName: repository.fullName))
                .filterSuccessfulStatusCodes()
                .debug()
                .mapArrayOptional(Issue.self)
    }
    
    internal func findRepository(name: String) -> Observable<[Repository]?> {
        return self.provider
                .request(GitHubService.Repos(username: name))
                .filterSuccessfulStatusCodes()
                .debug()
                .mapArrayOptional(Repository.self)
    }
}