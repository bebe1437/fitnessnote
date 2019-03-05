//
//  Workout.swift
//  fitnessNote
//
//  Created by 核心技術研發部-施郁嫻 on 2019/3/5.
//  Copyright © 2019 shihyuhsien. All rights reserved.
//

import Foundation
import CoreData

struct Workout{
    private let items = ["Shoulder Press", "Bench Press", "Deadlift", "Back Squat", "Front Squat"]
    private var records = [0.0,0.0,0.0,0.0,0.0]
    private var loaded = false
    
    mutating func updateRecords(Context context: NSManagedObjectContext, ItemId id: Int, ItemRecord record: Double){
        let personalRecord = PersonalRecord(context: context)
        personalRecord.setValue(id, forKey: "itemId")
        personalRecord.setValue(record, forKey: "itemRecord")
        records[id] = record
    }
    
    mutating func loadRecords(Context context: NSManagedObjectContext){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonalRecord")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                let itemId = data.value(forKey: "itemId") as! Int
                let itemRecord = data.value(forKey: "itemRecord") as! Double
                records[itemId] = itemRecord
            }
            loaded = true
        }catch{
            print("Failed")
        }
    }
    
    func commit(Context context: NSManagedObjectContext){
        do{
            try context.save()
            print("Sucessful saving")
        } catch{
            print("Failed saving")
        }
    }
    
    var Records: [Double]?{
        get{
            if loaded {
                return records
            }else{
                return nil
            }
        }
    }
    
    var Items: [String]?{
        get{
            return items
        }
    }
    
//
//    func preloadItem() -> Int{
//        print("preloadItem")
//
//        let context = container?.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutItem")
//        request.returnsObjectsAsFaults = false
//        do{
//            let result = try context?.fetch(request)
//            for data in result as! [NSManagedObject]{
//                print(data.value(forKey: "itemName") as! String)
//            }
//            return (result?.count)!
//        }catch{
//            print("Failed")
//            return Int(0)
//        }
//    }
//
//    func initWorkoutItem(){
//        print("initWorkoutItem")
//
//        let context = container?.viewContext
//
//        var index = 0
//        for item in items {
//            let workoutItem = WorkoutItem(context: context!)
//            workoutItem.setValue(index, forKey: "itemId")
//            workoutItem.setValue(item, forKey: "itemName")
//            index += 1
//        }
//
//        do{
//            try context?.save()
//            print("Sucessful saving")
//        } catch{
//            print("Failed saving")
//        }
//    }
//
}
