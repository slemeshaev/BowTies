//
//  BowTiesController.swift
//  BowTies
//
//  Created by Stanislav Lemeshaev on 11.01.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
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
    private var currentBowTie: BowTie!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = managedObjectContext()
        insertSampleData()
        fetchData()
    }
    
    // MARK: - IBActions
    @IBAction private func segmentedControl(_ sender: UISegmentedControl) {
        print(#function)
    }
    
    @IBAction private func wear(_ sender: UIButton) {
        let times = currentBowTie.timesWorn
        currentBowTie.timesWorn = times + 1
        currentBowTie.lastWorn = Date()
        
        do {
            try managedContext.save()
            populate(bowTie: currentBowTie)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    @IBAction private func rate(_ sender: UIButton) {
        let alertController = UIAlertController(title: "New Rating",
                                                message: "Rate this bow tie",
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            if let textField = alertController.textFields?.first {
                self.update(rating: textField.text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Private
    private func fetchData() {
        let request: NSFetchRequest<BowTie> = BowTie.fetchRequest()
        let firstTitle = segmentedControl.titleForSegment(at: 0)!
        request.predicate = NSPredicate(format: "%K = %@",
                                        argumentArray: [#keyPath(BowTie.searchKey), firstTitle])
        
        do {
            let results = try managedContext.fetch(request)
            currentBowTie = results.first
            populate(bowTie: results.first!)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func insertSampleData() {
        let fetch: NSFetchRequest<BowTie> = BowTie.fetchRequest()
        fetch.predicate = NSPredicate(format: "searchKey != nil")
        
        let count = try! managedContext.count(for: fetch)
        
        if count > 0 {
            return
        }
        
        let path = Bundle.main.path(forResource: "BowTiesData", ofType: "plist")
        
        let dataArray = NSArray(contentsOfFile: path!)!
        
        for dictionary in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "BowTie", in: managedContext)!
            let bowTie = BowTie(entity: entity, insertInto: managedContext)
            let bowTieDictionary = dictionary as! [String: Any]
            
            bowTie.id = UUID(uuidString: bowTieDictionary["id"] as! String)
            bowTie.name = bowTieDictionary["name"] as? String
            bowTie.searchKey = bowTieDictionary["searchKey"] as? String
            bowTie.rating = bowTieDictionary["rating"] as! Double
            
            let colorDictionary = bowTieDictionary["tintColor"] as! [String: Any]
            bowTie.tintColor = UIColor.from(dictionary: colorDictionary)
            
            let imageName = bowTieDictionary["imageName"] as? String
            let image = UIImage(named: imageName!)
            
            bowTie.imageData = image?.pngData()
            bowTie.lastWorn = bowTieDictionary["lastWorn"] as? Date
            
            let timesNumber = bowTieDictionary["timesWorn"] as! NSNumber
            bowTie.timesWorn = timesNumber.int32Value
            bowTie.isFavorite = bowTieDictionary["isFavorite"] as! Bool
            bowTie.url = URL(string: bowTieDictionary["url"] as! String)
        }
        
        try? managedContext.save()
    }
    
    private func populate(bowTie: BowTie) {
        guard let imageData = bowTie.imageData as Data?,
              let lastWorn = bowTie.lastWorn as Date?,
              let tintColor = bowTie.tintColor as? UIColor else {
                  return
              }
        
        imageView.image = UIImage(data: imageData)
        nameLabel.text = bowTie.name
        ratingLabel.text = "Rating: \(bowTie.rating)/5"
        timesWornLabel.text = "Times worn: \(bowTie.timesWorn)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        lastWornLabel.text = "Last worn: " + dateFormatter.string(from: lastWorn)
        
        favoriteLabel.isHidden = !bowTie.isFavorite
        
        view.tintColor = tintColor
    }
    
    private func update(rating: String?) {
        guard let ratingString = rating, let rating = Double(ratingString) else {
            return
        }
        
        do {
            currentBowTie.rating = rating
            try managedContext.save()
            populate(bowTie: currentBowTie)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    private func managedObjectContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
