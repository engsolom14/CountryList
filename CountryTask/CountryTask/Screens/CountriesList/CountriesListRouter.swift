//
//  CountriesListRouter.swift
//  CountryTask
//
//  Created by Eslam on 18/01/2025.
//

import UIKit
import SwiftUI

protocol CountriesListRouter {
    func goToDetails(country: Country)
}

class CountriesListRouterImplementation: CountriesListRouter {
    fileprivate weak var CountriesListViewController: CountriesListViewController?
    
    init(CountriesListViewController: CountriesListViewController) {
        self.CountriesListViewController = CountriesListViewController
    }
    
    func goToDetails(country: Country) {
        let detailView = DetailView(country: country)
        let hostingController = UIHostingController(rootView: detailView)
        hostingController.modalPresentationStyle = .formSheet
        CountriesListViewController?.navigationController?.present(hostingController, animated: true, completion: nil)
    }

}
