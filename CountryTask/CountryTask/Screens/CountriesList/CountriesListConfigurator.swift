//
//  CountriesListConfigurator.swift
//  CountryTask
//
//  Created by Eslam on 18/01/2025.
//

import Foundation


protocol CountriesListConfigurator {
    func configure(CountriesListViewController:CountriesListViewController)
}


class CountriesListConfiguratorImplementation {

    func configure(CountriesListViewController:CountriesListViewController) {
        let view = CountriesListViewController
        let router = CountriesListRouterImplementation(CountriesListViewController: view)
        
        let interactor = CountriesListInteractor()
        let presenter = CountriesListPresenterImplementation(view: view, router: router,interactor:interactor)
        
        
        CountriesListViewController.presenter = presenter
    }
    
}
