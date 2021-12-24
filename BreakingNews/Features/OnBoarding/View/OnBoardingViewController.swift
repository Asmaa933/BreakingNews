//
//  OnBoardingViewController.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

class OnBoardingViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var countryDropDown: CustomDropDown!
    @IBOutlet private weak var categoriesDropDown: CustomDropDown!
    
    //MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions

    @IBAction private func startAction(_ sender: BottomButton) {
    }
}

