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
    
    var workout = Workout()
    
    @IBOutlet weak var editable: UISwitch!
    @IBOutlet weak var prView: UICollectionView!
    @IBOutlet weak var trainingView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init personal record
        let context = container?.viewContext
        workout.loadRecords(Context: context!)
    }
    
    @objc func doneClicked(){
        view.endEditing(true)
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (workout.Items?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemValue = workout.Items?[indexPath.row] ?? ""
        let itemRecord = workout.Records?[indexPath.row] ?? 0.0
        
        if collectionView == self.trainingView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trainingMenuCell", for: indexPath) as! TrainingMenuCell
            cell.item.text = "\(itemValue)：\(itemRecord)"
            updateTrainingMenu(Cell: cell, PR: itemRecord)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personalRecordCell", for: indexPath) as! PersonalRecordCell
        cell.itemLabel.text = itemValue
        print("enabled:\(editable.isOn)")
        cell.recordText.isUserInteractionEnabled = editable.isOn
        if itemRecord != 0.0 {
            cell.recordText.text = String(itemRecord)
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
        cell.repo3.text = String(pr * 0.90)

    }
    
    @IBAction func editSwitch(_ sender: UISwitch) {
        
        var index = 0
        let context = container?.viewContext
        for cell in prView.visibleCells{
            let prCell = cell as! PersonalRecordCell
            print("\(sender.isOn)")
            print("\(prCell.itemLabel.text!)")
            prCell.recordText.isUserInteractionEnabled = sender.isOn
            prCell.recordText.isEnabled = sender.isOn
            
            let value = prCell.recordText.text!
            if !sender.isOn && value != ""{
                workout.updateRecords(Context: context!, ItemId: index, ItemRecord: Double(value)!)
            }
            index = index+1
        }
        
        if !sender.isOn {
            workout.commit(Context: context!)
            workout.loadRecords(Context: context!)
            
            index = 0
            let records = workout.Records
            for cell in trainingView.visibleCells{
                let trainCell = cell as! TrainingMenuCell
                updateTrainingMenu(Cell: trainCell, PR: Double(records![index]))
                index = index+1
            }
        }
    }
    
}

