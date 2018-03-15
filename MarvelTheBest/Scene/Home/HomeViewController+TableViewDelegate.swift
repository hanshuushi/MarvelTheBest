//
//  HomeViewController+TableViewDelegate.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/15.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch status {
        case .success(let viewModels, let showMore):
            if viewModels.count == 0 {
                return 1
            }
            
            return viewModels.count + (showMore ? 1 : 0)
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch status {
        case .success(let viewModels, let showMore):
            if showMore && indexPath.row >= viewModels.count {
                self.showMoreAction?()
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch status {
        case .loading:
            return 120
        case .success(let viewModels, _):
            if viewModels.count == 0 {
                return tableView.frame.height - 77
            }
            
            if indexPath.row < viewModels.count {
                let width = tableView.bounds.width
                
                let cellWidth = width - 50
                
                return cellWidth * 83 / 163 + 20
            }
            
            return 50
        case .failed(_):
            return tableView.frame.height - 77
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch status {
        case .loading:
            return 120
        case .success(let viewModels, _):
            if viewModels.count == 0 {
                return tableView.frame.height - 77
            }
            
            if indexPath.row < viewModels.count {
                let width = tableView.bounds.width
                
                let cellWidth = width - 50
                
                return cellWidth * 83 / 163 + 20
            }
            
            return 50
        case .failed(_):
            return tableView.frame.height - 77
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch status {
        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: "Loading", for: indexPath)
        case .success(let viewModels, _):
            if viewModels.count == 0 {
                return tableView.dequeueReusableCell(withIdentifier: "Empty", for: indexPath)
            }
            
            if indexPath.row < viewModels.count {
                let currentViewModel = viewModels[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Hero", for: indexPath)
                
                if let `cell` = cell as? HomeHeroTableViewCell {
                    currentViewModel.bind(to: cell)
                }
                
                return cell
            }
            
            return tableView.dequeueReusableCell(withIdentifier: "Loading", for: indexPath)
        default:
            
            return tableView.dequeueReusableCell(withIdentifier: "Failed", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch status {
        case .success(let viewModels, _):
            if indexPath.row >= viewModels.count {
                return
            }
            
            let currentViewModel = viewModels[indexPath.row]
            
            let detailVC = DetailViewController(heroViewModel: currentViewModel)
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        default:
            return
        }
    }
}
