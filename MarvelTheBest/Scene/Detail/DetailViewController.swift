//
//  DetailViewController.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation


enum DetailViewControllerStatus {
    case loading
    case failed(String)
    case success([HeroTabItemViewModel])
}

class DetailViewController: UIViewController {
    
    var status: DetailViewControllerStatus = .loading {
        didSet {
            tableView.reloadData()
        }
    }
    
    let viewModel: DetailViewModel
    
    
    init(heroViewModel: HomeHeroTableViewModel) {
        viewModel = DetailViewModel(heroId: heroViewModel.heroId)
        
        infoTableViewCell = HeroInfoTableViewCell(style: .default,
                                                  reuseIdentifier: "InfoHeader")
        
        infoTableViewCell.heroNameLabel.text = heroViewModel.heroName
        
        infoTableViewCell.heroDescLabel.text = heroViewModel.heroDesc
        
        if let url = heroViewModel.heroImage {
            infoTableViewCell.download(from: url)
        }
        
        infoTableViewCell.favButton.isSelected = FavoriteManager.share.isFav(of: heroViewModel.heroId)
        
        headerView = HeroTabHeader(reuseIdentifier: "TabHeader")
        
        tableView = UITableView(frame: UIScreen.main.bounds,
                                style: .plain)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let infoTableViewCell: HeroInfoTableViewCell
    
    let tableView: UITableView
    
    let headerView: HeroTabHeader

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        /// setup tableview
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(LoadingTableViewCell.self,
                           forCellReuseIdentifier: "Loading")
        tableView.register(EmptyTableVIewCell.self,
                           forCellReuseIdentifier: "Empty")
        tableView.register(ErrorTableViewCell.self,
                           forCellReuseIdentifier: "Failed")
        tableView.register(HeroTabItemTableViewCell.self,
                           forCellReuseIdentifier: "Item")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 29.0 / 255.0, green: 29.0 / 255.0, blue: 29.0 / 255.0, alpha: 1.0)
        
        self.view.addSubview(tableView)
        
        /// add pop button
        let popButton = UIButton()
        
        self.view.addSubview(popButton)
        
        popButton.frame = CGRect(x: 26, y: 34, width: 29, height: 29)
        popButton.setImage(UIImage(named: "back"), for: .normal)
        popButton.addTarget(self,
                            action: #selector(DetailViewController.popButtonPressed),
                            for: UIControlEvents.touchUpInside)
        
        viewModel.bind(to: self)
    }
    
    @objc func popButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            switch status {
            case .success(let viewModels):
                return max(1, viewModels.count)
            default:
                return 1
            }
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return infoTableViewCell
        case 1:
            switch status {
            case .loading:
                return tableView.dequeueReusableCell(withIdentifier: "Loading", for: indexPath)
            case .success(let viewModels):
                if viewModels.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Empty", for: indexPath)
                    
                    if let `cell` = cell as? EmptyTableVIewCell {
                        cell.tagLabel.text = "No Item Found"
                    }
                    
                    return cell
                }
                
                let currentViewModel = viewModels[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
                
                if let `cell` = cell as? HeroTabItemTableViewCell {
                    currentViewModel.bind(to: cell)
                }
                
                return cell
            default:
                return tableView.dequeueReusableCell(withIdentifier: "Failed", for: indexPath)
            }
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return infoTableViewCell.sizeThatFits(CGSize(width: tableView.bounds.width,
                                                         height: CGFloat.greatestFiniteMagnitude))
                .height
        case 1:
            switch status {
            case .loading:
                return 120
            default:
                return 186
            }
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return infoTableViewCell.sizeThatFits(CGSize(width: tableView.bounds.width,
                                                         height: CGFloat.greatestFiniteMagnitude))
                .height
        case 1:
            switch status {
            case .loading:
                return 120
            default:
                return 186
            }
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        
        return 60
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        infoTableViewCell.observerContentOffsetY(scrollView.contentOffset.y)
    }
}

fileprivate extension DetailViewController {
    
}
