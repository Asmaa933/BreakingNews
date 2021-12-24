//
//  OnBoardingViewController.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var countriesDropDown: CustomDropDown!
    @IBOutlet private weak var categoriesDropDown: CustomDropDown!
    
    //MARK: - Variables
    private var viewModel: OnBoardingViewModelProtocol
    
    //MARK: Init
    init(viewModel: OnBoardingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.statePresenter = self
        setupView()
    }
    
    //MARK: - Actions
    @IBAction private func startAction(_ sender: BottomButton) {
        viewModel.startHeadlines()
    }
}

fileprivate extension OnBoardingViewController {
    func setupView(){
        setupCountriesDropDown()
        setupCategoriesDropDown()
    }
    
    func setupCountriesDropDown() {
        countriesDropDown.dropMenuItems = viewModel.getCountries()
        countriesDropDown.didSelectItem = {[weak self] index in
            guard let self = self else { return }
            self.viewModel.selectedCountryIndex  = index
        }
    }
    
    func setupCategoriesDropDown() {
        categoriesDropDown.dropMenuItems = viewModel.getCategories()
        categoriesDropDown.didSelectItem = {[weak self] index in
            guard let self = self else { return }
            self.viewModel.selectedCategoryIndex  = index
        }
    }
    
    func navigateToHome() {
        setRootViewController(to: HomeViewController())
    }
}

extension OnBoardingViewController: StatePresentable {
    
    func render(state: State) {
        switch state {
        case .error(let message):
            show(errorMessage: message)
        case .populated:
            navigateToHome()
        default:
            break
        }
    }
}
