//
//  ViewController.swift
//  RxMoyaExample
//
//  Created by iMeraj-MacbookPro on 9/6/16.
//  Copyright © 2016 Sekai Lab BD. All rights reserved.
//

import Moya
import Moya_ModelMapper
import UIKit
import RxCocoa
import RxSwift

class ViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<GitHubService>!
    var latestRepositoryName: Observable<String> {
        return searchBar
            .rx_text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    var issueTrackerModel: IssueTrackerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nil
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "issueCell")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        setupRx()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupRx() {
        provider = RxMoyaProvider<GitHubService>()
        issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)
        
        issueTrackerModel
            .trackIssues()
            .bindTo(tableView.rx_itemsWithCellFactory) { (tableView, row, item) in
                let cell = tableView.dequeueReusableCellWithIdentifier("issueCell", forIndexPath: NSIndexPath(forRow: row, inSection: 0))
                cell.textLabel?.text = "[\(String(item.identifier))]: \(item.title)"
                return cell
        }.addDisposableTo(disposeBag)
        
        tableView
            .rx_itemSelected
            .subscribeNext { (indexPath) in
                if self.searchBar!.isFirstResponder() == true {
                    self.view.endEditing(true)
                }
        }.addDisposableTo(disposeBag)
    }
}

