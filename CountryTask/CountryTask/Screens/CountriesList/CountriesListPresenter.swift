//
//  CountriesListPresenter.swift
//  CountryTask
//
//  Created by Eslam on 18/01/2025.
//

import Foundation
import CoreLocation

protocol CountriesListView: AnyObject {
    func initUI()
    func showLoader()
    func hideLoader()
    func noData()
    func successData()
    func showAlert(title: String, msg: String)
    func showAPIErrorAlert(error: CustomError)
}

protocol CountriesListPresenter {
    func viewDidLoad()
    func refreshCountriesList()
    func didSelect(index: Int)
    func configureCell(cell: CountriesListCellView, forRow row: Int, with country: Country?)
    func getRequestsCount()->Int
    func search(with query: String) -> Void
    func getCountry(at index: Int) -> Country?
    func toggleFavorite(for index: Int)

}

protocol CountriesListCellView {
    func img(img:String)
    func name(name: String)
    func setFavoriteImage(name: String)

}

protocol CountriesListInteractorToPresenterProtocol:AnyObject{
    func fetchedData(result: Result<[Country] ,CustomError>)
}

class CountriesListPresenterImplementation: NSObject, CountriesListPresenter, CountriesListInteractorToPresenterProtocol, CLLocationManagerDelegate {
    
    fileprivate weak var view: CountriesListView?
    internal let router: CountriesListRouter
    internal let interactor : CountriesListInteractor

    var countriesObj = [Country]()
    var filteredCountries: [Country] = []
    var isSearching: Bool = false
    var favCountries: Set<UUID> = []
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?

    let defaultCountryName = "Egypt"
    
    init(view: CountriesListView,router: CountriesListRouter,interactor:CountriesListInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
        super.init()
        self.interactor.viewDidLoad(presenter: self)
        locationManager.delegate = self
    }

    
    func viewDidLoad() {
        self.view?.initUI()
        self.view?.showLoader()
        self.interactor.fetchData()
        self.loadFavorites()
        setupLocationServices()
    }
    
    func refreshCountriesList() {
        countriesObj.removeAll()
        self.interactor.fetchData()
    }
    
    func getRequestsCount() -> Int {
        return isSearching ? filteredCountries.count : countriesObj.count
    }
    
    func configureCell(cell: CountriesListCellView, forRow row: Int, with country: Country?) {
        guard let country = country else { return }
        cell.img(img: country.flags?.png ?? "")
        cell.name(name: country.name)
        let isFavorite = favCountries.contains(country.id)
        let favoriteImage = isFavorite ? "icon-heart" : "icon-heart-unfill"
        cell.setFavoriteImage(name: favoriteImage)
    }
    
    func toggleFavorite(for index: Int) {
        guard let country = getCountry(at: index) else { return }
        if favCountries.contains(country.id) {
            favCountries.remove(country.id)
        } else {
            if favCountries.count >= 5 {
                self.view?.showAlert(title: "ALERT!!", msg: "you reach max number to be added on main screen")
                return
            }
            
            favCountries.insert(country.id)
        }
        saveFavorites()
    }

    
    func getCountry(at index: Int) -> Country? {
        return isSearching ? filteredCountries[index] : countriesObj[index]
    }

    func search(with query: String) {
        if query.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filteredCountries = (countriesObj.filter { country in
                country.name.localizedCaseInsensitiveContains(query) ||
                (country.capital?.localizedCaseInsensitiveContains(query) ?? false)
            })
        }
        view?.successData()
    }
    
    func didSelect(index: Int) {
        guard let country = getCountry(at: index) else { return }
        self.router.goToDetails(country: country)
    }
    
    func fetchedData(result: Result<[Country], CustomError>) {
        self.view?.hideLoader()
        
            switch result {
            case .success(let countries):
                DispatchQueue.main.async {
                    self.countriesObj = countries
                    self.view?.successData()
                }
            case .failure(let failure):
                print("Error:", failure)
                self.view?.showAPIErrorAlert(error: failure)
            }
    }
    
    func addCountryBasedOnLocation() {
        guard let userLocation = userLocation else { return }

        if let closestCountry = countriesObj.min(by: { country1, country2 in
            guard let latlng1 = country1.latlng, let latlng2 = country2.latlng else { return false }
            let distance1 = CLLocation(latitude: latlng1[0], longitude: latlng1[1]).distance(from: userLocation)
            let distance2 = CLLocation(latitude: latlng2[0], longitude: latlng2[1]).distance(from: userLocation)
            return distance1 < distance2
        }) {
            addCountryToFavorites(country: closestCountry)
        } else {
            addDefaultCountry()
        }
    }

    func addDefaultCountry() {
        if let defaultCountry = countriesObj.first(where: { $0.name == defaultCountryName }) {
            addCountryToFavorites(country: defaultCountry)
        } else {
            print("Default country not found in the data.")
        }
    }
    
    func addCountryToFavorites(country: Country) {
            guard !favCountries.contains(country.id) else { return }
            favCountries.insert(country.id)
            view?.successData() // Refresh the view to reflect the change
        }
    
    func setupLocationServices() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        userLocation = location
        addCountryBasedOnLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        addDefaultCountry()
    }

    private func saveFavorites() {
        let favoriteIDs = Array(favCountries)
        UserDefaults.standard.setStruct(favoriteIDs, forKey: COUNTRIES_DATA)
    }

    private func loadFavorites() {
        if let savedIDs: [UUID] = UserDefaults.standard.getStructData([UUID].self, forKey: COUNTRIES_DATA) {
            favCountries = Set(savedIDs)
        }
        self.view?.successData()
    }
    
}
