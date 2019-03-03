//
//  ViewController.swift
//  fitnessNote
//
//  Created by shihyuhsien on 2019/3/3.
//  Copyright © 2019 shihyuhsien. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let items = ["Shoulder Press", "Bench Press", "Deadlift", "Back Squat", "Front Squat"]
    
    @IBOutlet weak var shoulderPress: UITextField!
    @IBOutlet weak var benchPress: UITextField!
    @IBOutlet weak var deadlift: UITextField!
    @IBOutlet weak var backSquat: UITextField!
    @IBOutlet weak var frontSquat: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar(frame: CGRect(x: 20.0, y:90.0, width: 280.0, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([doneButton], animated: false)
        
        shoulderPress.inputAccessoryView = toolbar
        benchPress.inputAccessoryView = toolbar
        deadlift.inputAccessoryView = toolbar
        backSquat.inputAccessoryView = toolbar
        frontSquat.inputAccessoryView = toolbar
//
//        shoulderPress.delegate = self as? UITextFieldDelegate
//        benchPress.delegate = self as? UITextFieldDelegate
//        deadlift.delegate = self as? UITextFieldDelegate
//        backSquat.delegate = self as? UITextFieldDelegate
//        frontSquat.delegate = self as? UITextFieldDelegate
    }
    
    @objc func doneClicked(){
        view.endEditing(true)
    }
  
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        textField.resignFirstResponder()
//        return true
//    }
//
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        print("shoulderPress：\(shoulderPress.text!)")
        print("benchPress：\(benchPress.text!)")
        print("deadlift：\(deadlift.text!)")
        print("backSquat：\(backSquat.text!)")
        print("frontSquat：\(frontSquat.text!)")
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trainingMenuCell", for: indexPath) as! TrainingMenuCell
        
        let itemValue = items[indexPath.row]
        cell.item.text = itemValue
        
        print("row:\(indexPath.row), value:\(itemValue)")
        switch(itemValue){
        case "Shoulder Press":
            updateTrainingMenu(Cell: cell, PRText: shoulderPress)
            break
        case "Bench Press":
            updateTrainingMenu(Cell: cell, PRText: benchPress)
            break
        case "Deadlift":
            updateTrainingMenu(Cell: cell, PRText: deadlift)
            break
        case "Front Squat":
            updateTrainingMenu(Cell: cell, PRText: frontSquat)
            break
        case "Back Squat":
            updateTrainingMenu(Cell: cell, PRText: backSquat)
            break
        default:
            break
        }
        
        return cell
    }
    
    private func updateTrainingMenu(Cell cell: TrainingMenuCell, PRText prText: UITextField!){
        let pr = prText.text != nil && prText.text! != "" ? Double(prText.text!)! : 0
        
        cell.repo12.text = String(pr * 0.75)
        cell.repo8.text = String(pr * 0.80)
        cell.repo5.text = String(pr * 0.85)
        cell.repo3.text = String(pr * 0.90)}
    
}

