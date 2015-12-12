//
//  HealthManager.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 11/5/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

//import UIKit
import HealthKit
import Foundation


class HealthManager {

    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((success: Bool, error: NSError!) -> Void)!) {
        let healthKitTypesToRead = Set(arrayLiteral:
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            HKObjectType.workoutType()
            )
        let healthKitTypesToWrite = Set(arrayLiteral:
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKQuantityType.workoutType()
        )
        if !HKHealthStore.isHealthDataAvailable() {
// need past domain
            let error = NSError(domain: "DOMAIN.healtKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available in this Device"])
            if (completion != nil)
            {
                completion(success: false, error: error)
            }
            return;
        }
        healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead) {
            
        (success,error) -> Void in
            if (completion != nil) {
                completion(success: success, error: error)
            }
        }
    }
    func saveRunningWorkout(startDate: NSDate, endDate: NSDate, distance: Double, distanceUnit: HKUnit, kiloCalories: Double, competion: ((Bool, NSError!) -> Void)!) {
        let distanceQuantity = HKQuantity(unit: distanceUnit, doubleValue: distance)
        let caloriesQuantity = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: kiloCalories)
        
        let workout = HKWorkout(activityType: HKWorkoutActivityType.Running, startDate: startDate, endDate: endDate, duration: abs(endDate.timeIntervalSinceDate(startDate)), totalEnergyBurned: caloriesQuantity, totalDistance: distanceQuantity, metadata:  nil)
        healthKitStore.saveObject(workout, withCompletion: {(success, error) -> Void in
            if (error != nil) {
                competion(success, error)
            }
            else {
                competion(success, error)
            }
        })
    }
    
    func readRunningWorkOuts(completion: (([AnyObject]!, NSError!) -> Void)!) {
        let predicate = HKQuery.predicateForWorkoutsWithWorkoutActivityType(HKWorkoutActivityType.Running)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor], resultsHandler: {(sampleQuery, results, error) -> Void in
            if let queryError = error {
                print("There was an error while reading the samples: \(queryError.localizedDescription)")
            }
            completion(results, error)
        })
        healthKitStore.executeQuery(sampleQuery)
    }
}
