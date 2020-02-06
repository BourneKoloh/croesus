//
//  DbContext.swift
//  Croesus
//
//  Created by Bourne K on 04/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation
import CoreData

class DataContext:NSObject {
    
    static let DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    private static var _inst:DataContext?
    static var Shared:DataContext{
        get{
            if _inst == nil {
                _inst = DataContext()
            }
            return _inst!
        }
    }
    var dateFormat = DateFormatter()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Croesus")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    //
    lazy var backgroundContext: NSManagedObjectContext = {
        //
        let newbackgroundContext = persistentContainer.newBackgroundContext()
        //
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        //
        return newbackgroundContext
    }()
    //MARK: -
    override private init() {
        super.init()
        dateFormat.dateFormat = DataContext.DATE_FORMAT
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    //MARK: -
    func storeSurvey(_ survey:SurveyItem) -> Bool {
        //
        do{
            let entity = NSEntityDescription.entity(forEntityName:SurveyEntity.TABLE_NAME, in: backgroundContext)!
            //
            let entry = NSManagedObject(entity: entity, insertInto: backgroundContext)
            //
            entry.setValue(survey.id, forKeyPath: SurveyEntity.COLUMN_ID)
            entry.setValue(survey.title, forKeyPath: SurveyEntity.COLUMN_TITLE)
            entry.setValue(survey.desc, forKeyPath: SurveyEntity.COLUMN_DESC)
            //
            entry.setValue(dateFormat.string(from: survey.dateAdded ?? Date()), forKeyPath: SurveyEntity.COLUMN_DATE_ADDED)
            //
            try backgroundContext.save()
            
            //
            for k in survey.questions {
                let _ = storeQuestion(k, survey.id)
            }
          
        } catch let error as NSError {
            print(error)
          return false
        }
        
        return true
    }
    //MARK:
    func getSurveys(_ kind:SurveyKind) -> [SurveyItem] {
        
        var list = [SurveyItem]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: SurveyEntity.TABLE_NAME)
        //
        fetchRequest.predicate = NSPredicate(format: "\(SurveyEntity.COLUMN_KIND) = %@", argumentArray: ["\(kind.rawValue)"])
        //
        do {
            let records = try backgroundContext.fetch(fetchRequest)
            for r0 in records {
                
                let entry = SurveyItem()
                //
                entry.title = r0.value(forKeyPath: SurveyEntity.COLUMN_TITLE) as? String ?? ""
                entry.id = Int(r0.value(forKeyPath: SurveyEntity.COLUMN_ID) as? String ?? "0") ?? 0
                //
                switch Int(r0.value(forKeyPath: SurveyEntity.COLUMN_KIND) as? String ?? "0") ?? 0 {
                    case SurveyKind.Ongoing.rawValue:
                        entry.kind = .Ongoing
                    break
                    case SurveyKind.Completed.rawValue:
                        entry.kind = .Completed
                    break
                    default:
                        entry.kind = .All
                    break
                }
                //
                entry.dateAdded = dateFormat.date(from: r0.value(forKeyPath: SurveyEntity.COLUMN_DATE_ADDED) as? String ?? "")
                //
                entry.questions.append(contentsOf: getSurveyQuestions(entry.id))
                //
                list.append(entry)
            }
        }catch let error as NSError{
            print(error)
        }
        
        return list
    }

    //MARK: -
    func storeQuestion(_ question:SurveyQuestion, _ surveyId:Int) -> Bool {
        //
        do{
            let entity = NSEntityDescription.entity(forEntityName:QuestionEntity.TABLE_NAME, in: backgroundContext)!
            //
            let entry = NSManagedObject(entity: entity, insertInto: backgroundContext)
            //
            entry.setValue(question.id, forKeyPath: QuestionEntity.COLUMN_ID)
            entry.setValue(question.title, forKeyPath: QuestionEntity.COLUMN_TITLE)
            entry.setValue(question.type.rawValue, forKeyPath: QuestionEntity.COLUMN_TYPE)
            //
            entry.setValue(surveyId, forKeyPath: QuestionEntity.COLUMN_SURVEY)
            //
            entry.setValue(dateFormat.string(from: question.dateAdded ?? Date()), forKeyPath: QuestionEntity.COLUMN_DATE_ADDED)
            //
            try backgroundContext.save()
            
            //
            for j in question.answers {
                let _ = storeAnswer(j, question.id)
            }
            //
            for k in question.choices {
                let _ = storeChoice(k,question.id)
            }
          
        } catch let error as NSError {
            print(error)
          return false
        }
        
        return true
    }
    //MARK:
    func getSurveyQuestions(_ surveyId:Int) ->[SurveyQuestion] {
        //
        var list = [SurveyQuestion]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: QuestionEntity.TABLE_NAME)
        
        //
        fetchRequest.predicate = NSPredicate(format: "\(QuestionEntity.COLUMN_SURVEY) = %@", argumentArray: ["\(surveyId)"])
        //
        do {
            let records = try backgroundContext.fetch(fetchRequest)
            for r0 in records {
                
                let entry = SurveyQuestion()
                //
                entry.title = r0.value(forKeyPath: QuestionEntity.COLUMN_TITLE) as? String ?? ""
                entry.id = Int(r0.value(forKeyPath: QuestionEntity.COLUMN_ID) as? String ?? "0") ?? 0
                //
                switch Int(r0.value(forKeyPath: QuestionEntity.COLUMN_TYPE) as? String ?? "0") ?? 0 {
                case AnswerKind.MultipleChoice.rawValue:
                    entry.type = .MultipleChoice
                    break
                    case AnswerKind.SingleChoice.rawValue:
                        entry.type = .SingleChoice
                    break
                    default:
                        entry.type = .Text
                    break
                }
                //
                entry.dateAdded = dateFormat.date(from: r0.value(forKeyPath: QuestionEntity.COLUMN_DATE_ADDED) as? String ?? "")
                //
                entry.choices.append(contentsOf: getQuestionChoices(entry.id))
                entry.answers.append(contentsOf: getQuestionAnswers(entry.id))
                //
                list.append(entry)
            }
        }catch let error as NSError{
            print(error)
        }
        
        return list
    }
    
    //MARK: -
    func storeChoice(_ choice:QuestionChoice, _ questionId:Int) -> Bool {
        //
        do{
            let entity = NSEntityDescription.entity(forEntityName:ChoiceEntity.TABLE_NAME, in: backgroundContext)!
            //
            let entry = NSManagedObject(entity: entity, insertInto: backgroundContext)
            //
            entry.setValue(choice.id, forKeyPath: ChoiceEntity.COLUMN_ID)
            entry.setValue(choice.title, forKeyPath: ChoiceEntity.COLUMN_TITLE)
            entry.setValue(choice.value, forKeyPath: ChoiceEntity.COLUMN_VALUE)
            //
            entry.setValue(questionId, forKeyPath: ChoiceEntity.COLUMN_QUESTION)
            //
            entry.setValue(dateFormat.string(from: choice.dateAdded ?? Date()), forKeyPath: ChoiceEntity.COLUMN_DATE_ADDED)
            //
            try backgroundContext.save()
            
            //
            
          
        } catch let error as NSError {
            print(error)
          return false
        }
        
        return true
    }
    //MARK:
    func getQuestionChoices(_ questionId:Int) ->[QuestionChoice] {
        //
        var list = [QuestionChoice]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ChoiceEntity.TABLE_NAME)
        
        //
        fetchRequest.predicate = NSPredicate(format: "\(ChoiceEntity.COLUMN_QUESTION) = %@", argumentArray: ["\(questionId)"])
        //
        do {
            let records = try backgroundContext.fetch(fetchRequest)
            for r0 in records {
                
                let entry = QuestionChoice()
                //
                entry.title = r0.value(forKeyPath: ChoiceEntity.COLUMN_TITLE) as? String ?? ""
                entry.id = Int(r0.value(forKeyPath: ChoiceEntity.COLUMN_ID) as? String ?? "0") ?? 0
                //
                entry.value = r0.value(forKeyPath: ChoiceEntity.COLUMN_VALUE) as? String ?? ""
                //
                entry.dateAdded = dateFormat.date(from: r0.value(forKeyPath: ChoiceEntity.COLUMN_DATE_ADDED) as? String ?? "")
                //
                
                //
                list.append(entry)
            }
        }catch let error as NSError{
            print(error)
        }
        
        return list
    }
    
    //MARK: -
    func storeAnswer(_ answer:QuestionAnswer, _ questionId:Int) -> Bool {
        //
        do{
            let entity = NSEntityDescription.entity(forEntityName:AnswerEntity.TABLE_NAME, in: backgroundContext)!
            //
            let entry = NSManagedObject(entity: entity, insertInto: backgroundContext)
            //
            entry.setValue(answer.id, forKeyPath: AnswerEntity.COLUMN_ID)
            entry.setValue(answer.value, forKeyPath: AnswerEntity.COLUMN_VALUE)
            //
            entry.setValue(questionId, forKeyPath: AnswerEntity.COLUMN_QUESTION)
            //
            entry.setValue(dateFormat.string(from: answer.dateAdded ?? Date()), forKeyPath: AnswerEntity.COLUMN_DATE_ADDED)
            //
            try backgroundContext.save()
            
            //
            
          
        } catch let error as NSError {
            print(error)
          return false
        }
        
        return true
    }
    //MARK:
    func getQuestionAnswers(_ questionId:Int) ->[QuestionAnswer] {
        //
        var list = [QuestionAnswer]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: AnswerEntity.TABLE_NAME)
        
        //
        fetchRequest.predicate = NSPredicate(format: "\(AnswerEntity.COLUMN_QUESTION) = %@", argumentArray: ["\(questionId)"])
        //
        do {
            let records = try backgroundContext.fetch(fetchRequest)
            for r0 in records {
                
                let entry = QuestionAnswer()
                //
                entry.id = Int(r0.value(forKeyPath: AnswerEntity.COLUMN_ID) as? String ?? "0") ?? 0
                //
                entry.value = r0.value(forKeyPath: AnswerEntity.COLUMN_VALUE) as? String ?? ""
                //
                entry.dateAdded = dateFormat.date(from: r0.value(forKeyPath: AnswerEntity.COLUMN_DATE_ADDED) as? String ?? "")
                //
                
                //
                list.append(entry)
            }
        }catch let error as NSError{
            print(error)
        }
        
        return list
    }
}
