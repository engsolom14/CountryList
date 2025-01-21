//
//  CountriesListViewController.swift
//  CountryTask
//
//  Created by Eslam on 18/01/2025.
//

import UIKit

import SwiftUI

final class CountriesListViewController: UIViewController {
    
    var configurator = CountriesListConfiguratorImplementation()
    var presenter: CountriesListPresenter?
    // MARK: - UIViewController Events
    
    @IBOutlet weak var countryiesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cellID = "CountryCell"
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    public init () {
        super.init(nibName: "CountriesList", bundle: Bundle(for: CountriesListViewController.self))
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerCell() {
        self.countryiesCollectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
    }
    
    //MARK: pull to refresh
    func refreshController() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        countryiesCollectionView.addSubview(refreshControl)
    }
    @objc func refresh(_ sender: AnyObject) {
        presenter?.refreshCountriesList()
    }

}



extension CountriesListViewController: CountriesListView {
    func initUI() {
        registerCell()
        refreshController()
    }
    
    func showLoader() {
        self.view.showAnimatedSkeleton()
    }
    
    func noData() {
        print("NO DATA")
        refreshControl.endRefreshing()

    }
    
    func hideLoader() {
        self.view.hideSkeleton()
    }
    
    func successData() {
        DispatchQueue.main.async {
            self.countryiesCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
        refreshControl.endRefreshing()

    }

    func showAPIErrorAlert(error: CustomError) {
        self.networkFailureResponse(error: error)
        refreshControl.endRefreshing()

    }

}

//MARK: CollectionView
extension CountriesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (presenter?.getRequestsCount() == 0) ? 10:presenter?.getRequestsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = countryiesCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CountryCell {
            //cell.showAnimatedSkeleton()
            if presenter?.getRequestsCount() != 0 {
                cell.hideSkeletonView()
                self.presenter?.configureCell(cell: cell, forRow: indexPath.row, with: presenter?.getCountry(at: indexPath.row))
                
                cell.selectedIndex = {
                    print("SELECTED INT", indexPath.row)
                    self.presenter?.toggleFavorite(for: indexPath.row)
                }
                
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 5
        let cvWidth = collectionView.bounds.width / 2 - padding
        return CGSize(width: cvWidth, height: 210)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if presenter?.getRequestsCount() != 0 {
            self.presenter?.didSelect(index: indexPath.row)
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension CountriesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        presenter?.search(with: "")
    }
}
