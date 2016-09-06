//
//  IssueTrackerModel.swift
//  RxMoyaExample
//
//  Created by iMeraj-MacbookPro on 9/6/16.
//  Copyright © 2016 Sekai Lab BD. All rights reserved.
//

import Foundation

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
            .flatMapLatest { name -> Observable<Repository?> in
                print("Name: \(name)")
                return self.findRepository(name)
            }
            .flatMapLatest { repository -> Observable<[Issue]?> in
                guard let repository = repository else { return Observable.just(nil) }
                
                print("Repository: \(repository.fullName)")
                return self.findIssues(repository)
            }
            .replaceNilWith([])
    }
    
    internal func findIssues(repository: Repository) -> Observable<[Issue]?> {
        return self.provider
            .request(GitHubService.Issues(repositoryFullName: repository.fullName))
            .debug()
            .mapArrayOptional(Issue.self)
    }
    
    internal func findRepository(name: String) -> Observable<Repository?> {
        return self.provider
                .request(GitHubService.Repo(fullName: name))
                .debug()
                .mapObjectOptional(Repository.self)
    }
}