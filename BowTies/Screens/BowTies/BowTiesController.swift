//
//  BowTiesController.swift
//  BowTies
//
//  Created by Stanislav Lemeshaev on 11.01.2022.
//

import UIKit
import CoreData

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
    
    // MARK: - Properties
    private var managedContext: NSManagedObjectContext!
    
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
    
    // MARK: - Private
    private func insertSampleData() {
        
        let fetch: NSFetchRequest<BowTie> = BowTie.fetchRequest()
        fetch.predicate = NSPredicate(format: "searchKey != nil")
        
        let count = try! managedContext.count(for: fetch)
        
        if count > 0 {
            return
        }
        
        guard let path = Bundle.main.path(forResource: "SampleData", ofType: "plist") else {
            return
        }
        
        guard let dataArray = NSArray(contentsOfFile: path) else {
            return
        }
        
        for dictionary in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "BowTie", in: managedContext) else {
                return
            }
            
            let bowTie = BowTie(entity: entity, insertInto: managedContext)
            let bowTieDictionary = dictionary as! [String: Any]
            
            bowTie.id = UUID(uuidString: bowTieDictionary["id"] as! String)
            bowTie.name = bowTieDictionary["name"] as? String
            bowTie.searchKey = bowTieDictionary["searchKey"] as? String
            bowTie.rating = bowTieDictionary["rating"] as! Double
            
            let colorDictionary = bowTieDictionary["tintColor"] as! [String: Any]
            bowTie.tintColor = UIColor.color(dictionary: colorDictionary)
            
            guard let imageName = bowTieDictionary["imageName"] as? String else {
                return
            }
            
            let image = UIImage(named: imageName)
            
            bowTie.imageData = image?.pngData()
            bowTie.lastWorn = bowTieDictionary["lastWorn"] as? Date
            
            let timesNumber = bowTieDictionary["timesWorn"] as! NSNumber
            bowTie.timesWorn = timesNumber.int32Value
            bowTie.isFavorite = bowTieDictionary["isFavorite"] as! Bool
            bowTie.url = URL(string: bowTieDictionary["url"] as! String)
        }
        
        try! managedContext.save()
    }
    
}
