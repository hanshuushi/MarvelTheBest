//
//  HomeViewController.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/12.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import UIKit

enum HomeViewControllerStatus {
    case loading
    case failed(String)
    case success([HomeHeroTableViewModel], Bool)
}

class HomeViewController: UIViewController {
    
    let viewModel: HomeViewModel
    
    let tableView: UITableView
    
    let navigationView: UIView
    
    let searchButton: UIButton
    
    let marvelImageView: UIImageView
    
    let searchTextField: UITextField
    
    let rightButton: UIButton
    
    let maskView: UIView
    
    var status: HomeViewControllerStatus {
        didSet {
            tableView.reloadData()
        }
    }
    
    var showMoreAction: (() -> Void)? = nil
    
    var searchAction:((String) -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: UIScreen.main.bounds,
                                style: .plain)
        
        status = .loading
        
        viewModel = HomeViewModel()
        
        navigationView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
                                              height: 77))
        
        searchButton = UIButton()
        
        marvelImageView = UIImageView(image: UIImage(named: "marvel"))
        
        searchTextField = UITextField(frame: CGRect(x: 26, y: 28, width: UIScreen.main.bounds.width - 26, height: 42))
        
        maskView = UIView()
        
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 77, height: 42))
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        /// setup tableview
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        /// setup tableview
        tableView.contentInset = UIEdgeInsetsMake(77, 0, 0, 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.register(LoadingTableViewCell.self,
                           forCellReuseIdentifier: "Loading")
        tableView.register(HomeHeroTableViewCell.self,
                           forCellReuseIdentifier: "Hero")
        tableView.register(EmptyTableVIewCell.self,
                           forCellReuseIdentifier: "Empty")
        tableView.register(ErrorTableViewCell.self,
                           forCellReuseIdentifier: "Failed")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        /// search
        viewDidLoadSearch()
        
        
        viewModel.bind(to: self)
    }
}



