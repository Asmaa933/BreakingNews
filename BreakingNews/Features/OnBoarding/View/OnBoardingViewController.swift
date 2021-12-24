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

    }
    
    //MARK: - Actions
    @IBAction private func startAction(_ sender: BottomButton) {
        
    }
}
