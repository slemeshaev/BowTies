//
//  BowTiesController.swift
//  BowTies
//
//  Created by Stanislav Lemeshaev on 11.01.2022.
//

import UIKit

class BowTiesController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var timesWornLabel: UILabel!
    @IBOutlet private weak var lastWornLabel: UILabel!
    @IBOutlet private weak var favoriteLabel: UILabel!
    @IBOutlet private weak var wearButton: UIButton!
    @IBOutlet private weak var rateButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction private func segmentedControl(_ sender: UISegmentedControl) {
        print(#function)
    }
    
    @IBAction private func wear(_ sender: UIButton) {
        print(#function)
    }
    
    @IBAction private func rate(_ sender: UIButton) {
        print(#function)
    }
}
