//
//  ViewController.swift
//  CountryTask
//
//  Created by Eslam on 18/01/2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = CountriesListViewController()
        CountriesListConfiguratorImplementation().configure(CountriesListViewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

