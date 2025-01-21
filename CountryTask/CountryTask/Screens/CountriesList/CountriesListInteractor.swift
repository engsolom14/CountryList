//
//  CountriesListInteractor.swift
//  CountryTask
//
//  Created by Eslam on 18/01/2025.
//

import Foundation

protocol CountriesListInteractorProtocol {
     func viewDidLoad(presenter:CountriesListInteractorToPresenterProtocol?)
     func fetchData()
}

class CountriesListInteractor: CountriesListInteractorProtocol {
    fileprivate weak var  presenter:CountriesListInteractorToPresenterProtocol?
    
    func viewDidLoad(presenter: CountriesListInteractorToPresenterProtocol?) {
        self.presenter = presenter
    }
    
    func fetchData() {
        
        APIClient().executeQuery(params: [:], mapTo: APIRouter.countriesList) { [weak self](result: Result<[Country] ,CustomError>) in
            guard let self = self else { return  }
            self.presenter?.fetchedData(result: result)
        }

    }

 }
