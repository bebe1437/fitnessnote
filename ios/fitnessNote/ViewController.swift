//
//  ViewController.swift
//  fitnessNote
//
//  Created by shihyuhsien on 2019/3/3.
//  Copyright © 2019 shihyuhsien. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    let items = ["Shoulder Press", "Bench Press", "Deadlift", "Back Squat", "Front Squat"]
    var records = [0.0,0.0,0.0,0.0,0.0]
    
    @IBOutlet weak var editable: UISwitch!
    
    @IBOutlet weak var prView: UICollectionView!
    @IBOutlet weak var trainingView: UICollectionView!
    
    @IBAction func editSwitch(_ sender: UISwitch) {
        
        var index = 0
        for cell in prView.visibleCells{
            let prCell = cell as! PersonalRecordCell
            print("\(sender.isOn)")
            print("\(prCell.itemLabel.text!)")
            prCell.recordText.isUserInteractionEnabled = sender.isOn
            prCell.recordText.isEnabled = sender.isOn
            
            let value = prCell.recordText.text!
            if !sender.isOn && value != ""{
                records[index] = Double(value)!
            }
            index = index+1
        }
        
        if !sender.isOn {
            updatePersonalRecord()
            
            index = 0
            for cell in trainingView.visibleCells{
                let trainCell = cell as! TrainingMenuCell
                updateTrainingMenu(Cell: trainCell, PR: Double(records[index]))
                index = index+1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init workout items
        let count = preloadItem()
        if count == 0{
            initWorkoutItem()
        }
        //init personal record
        preloadRecord()
        
    }
    
    @objc func doneClicked(){
        view.endEditing(true)
    }
    
    func preloadItem() -> Int{
        print("preloadItem")
        
        let context = container?.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutItem")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context?.fetch(request)
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "itemName") as! String)
            }
            return (result?.count)!
        }catch{
            print("Failed")
            return Int(0)
        }
    }
    
    func preloadRecord(){
        print("preloadRecord")
        
        let context = container?.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonalRecord")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context?.fetch(request)
            for data in result as! [NSManagedObject]{
                let itemId = data.value(forKey: "itemId") as! Int
                let itemRecord = data.value(forKey: "itemRecord") as! Double
                records[itemId] = itemRecord
            }
        }catch{
            print("Failed")
        }
    }
    
    func updatePersonalRecord(){
        print("updatePersonalRecord")
        
        let context = container?.viewContext
        var index = 0
        for _ in items {
            let record = PersonalRecord(context: context!)
            record.setValue(index, forKey: "itemId")
            record.setValue(records[index], forKey: "itemRecord")
            index += 1
        }
        
        //TODO alert
        do{
            try context?.save()
            print("Sucessful saving")
        } catch{
            print("Failed saving")
        }
    }
    
    func initWorkoutItem(){
        print("initWorkoutItem")
        
        let context = container?.viewContext
        
        var index = 0
        for item in items {
            let workoutItem = WorkoutItem(context: context!)
            workoutItem.setValue(index, forKey: "itemId")
            workoutItem.setValue(item, forKey: "itemName")
            index += 1
        }
        
        do{
            try context?.save()
            print("Sucessful saving")
        } catch{
            print("Failed saving")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemValue = items[indexPath.row]
        print("row:\(indexPath.row), value:\(itemValue)")
        
        if collectionView == self.trainingView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trainingMenuCell", for: indexPath) as! TrainingMenuCell
            cell.item.text = "\(itemValue)：\(records[indexPath.row])"
            updateTrainingMenu(Cell: cell, PR: records[indexPath.row])
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personalRecordCell", for: indexPath) as! PersonalRecordCell
        cell.itemLabel.text = itemValue
        print("enabled:\(editable.isOn)")
        cell.recordText.isUserInteractionEnabled = editable.isOn
        if records[indexPath.row] != 0.0 {
            cell.recordText.text = String(records[indexPath.row])
        }
        
        //keyboard: doneBarButton
        let toolbar = UIToolbar(frame: CGRect(x: 20.0, y:90.0, width: 280.0, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([doneButton], animated: false)
        cell.recordText.inputAccessoryView = toolbar
        
        return cell
    }
    
    private func updateTrainingMenu(Cell cell: TrainingMenuCell, PR value: Double){
        let pr = value
        
        cell.repo12.text = String(pr * 0.75)
        cell.repo8.text = String(pr * 0.80)
        cell.repo5.text = String(pr * 0.85)
        cell.repo3.text = String(pr * 0.90)}
    
}

