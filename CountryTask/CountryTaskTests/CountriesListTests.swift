//
//  CountriesListTests.swift
//  CountryTaskTests
//
//  Created by Eslam on 21/01/2025.
//

import XCTest
@testable import CountryTask

final class CountriesListPresenterTests: XCTestCase {

    // Mock dependencies
    class MockView: CountriesListView {
        var didCallInitUI = false
        var didCallShowLoader = false
        var didCallHideLoader = false
        var didCallSuccessData = false
        var didCallShowAlert = false
        var alertTitle: String?
        var alertMessage: String?

        var navigationController: UINavigationController?

        func initUI() {
            didCallInitUI = true
        }

        func showLoader() {
            didCallShowLoader = true
        }

        func hideLoader() {
            didCallHideLoader = true
        }

        func noData() { }

        func successData() {
            didCallSuccessData = true
        }

        func showAlert(title: String, message: String) {
            didCallShowAlert = true
            alertTitle = title
            alertMessage = message
        }
    }

    class MockRouter: CountriesListRouter {
        var didCallGoToDetails = false
        var passedCountry: Country?

        func goToDetails(from navigationController: UINavigationController?, with country: Country) {
            didCallGoToDetails = true
            passedCountry = country
        }
    }

    class MockInteractor: CountriesListInteractor {
        var didCallFetchData = false
        var presenter: CountriesListInteractorToPresenterProtocol?

        func fetchData() {
            didCallFetchData = true
            let mockCountries = [
                Country(name: "United States", capital: "Washington, D.C.", currencies: nil, latlng: [38.0, -97.0], flags: nil),
                Country(name: "France", capital: "Paris", currencies: nil, latlng: [46.0, 2.0], flags: nil)
            ]
            presenter?.fetchedData(result: .success(mockCountries))
        }

        func viewDidLoad(presenter: CountriesListInteractorToPresenterProtocol) {
            self.presenter = presenter
        }
    }

    // Test properties
    var mockView: MockView!
    var mockRouter: MockRouter!
    var mockInteractor: MockInteractor!
    var presenter: CountriesListPresenterImplementation!

    override func setUp() {
        super.setUp()
        mockView = MockView()
        mockRouter = MockRouter()
        mockInteractor = MockInteractor()
        presenter = CountriesListPresenterImplementation(view: mockView, router: mockRouter, interactor: mockInteractor)
    }

    override func tearDown() {
        mockView = nil
        mockRouter = nil
        mockInteractor = nil
        presenter = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockView.didCallInitUI)
        XCTAssertTrue(mockView.didCallShowLoader)
        XCTAssertTrue(mockInteractor.didCallFetchData)
    }

    func testFetchDataSuccess() {
        presenter.viewDidLoad()
        XCTAssertEqual(presenter.getRequestsCount(), 2) // MockInteractor returns 2 countries
    }

    func testToggleFavorite() {
        presenter.viewDidLoad()

        // Add first country to favorites
        presenter.toggleFavorite(for: 0)
        XCTAssertEqual(presenter.getRequestsCount(), 2)
        XCTAssertTrue(mockView.didCallSuccessData)

        // Exceed the favorite limit
        presenter.toggleFavorite(for: 1) // Second country added
        presenter.toggleFavorite(for: 0) // First country re-added
        presenter.toggleFavorite(for: 0) // Limit reached

        // Ensure alert is shown
        XCTAssertTrue(mockView.didCallShowAlert)
        XCTAssertEqual(mockView.alertTitle, "Limit Reached")
        XCTAssertEqual(mockView.alertMessage, "You can only add up to 5 favorite countries.")
    }

    func testSearch() {
        presenter.viewDidLoad()
        presenter.search(with: "United")
        XCTAssertEqual(presenter.getRequestsCount(), 1) // "United States" matches
        presenter.search(with: "")
        XCTAssertEqual(presenter.getRequestsCount(), 2) // All countries restored
    }

    func testDidSelect() {
        presenter.viewDidLoad()
        presenter.didSelect(index: 0)
        XCTAssertTrue(mockRouter.didCallGoToDetails)
        XCTAssertEqual(mockRouter.passedCountry?.name, "United States")
    }
}
