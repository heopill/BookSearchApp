//
//  CoreDataManager.swift
//  BookSearchApp
//
//  Created by 허성필 on 5/14/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var container: NSPersistentContainer!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    // CoreData 데이터 저장하기
    func createData(title: String, author: String, price: Int, thumbnail: String, contents: String, isbn: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: BookData.className, in: self.container.viewContext) else { return }
        let newContacts = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        
        newContacts.setValue(title, forKey: BookData.Key.title)
        newContacts.setValue(author, forKey: BookData.Key.author)
        newContacts.setValue(price, forKey: BookData.Key.price)
        newContacts.setValue(thumbnail, forKey: BookData.Key.thumbnail)
        newContacts.setValue(contents, forKey: BookData.Key.contents)
        newContacts.setValue(isbn, forKey: BookData.Key.isbn)
        
        do {
            try self.container.viewContext.save()
            print("책 담기 성공")
        } catch {
            print("책 담기 실패")
        }
    }
    
    // CoreData 저장된 데이터 선택 삭제
    func deleteData(isbn: String) {
        // 삭제할 데이터를 찾기 위한 fetch request 생성
        let fetchRequest = BookData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            // fetch request 실행
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            // 결과 처리
            for data in result as [NSManagedObject] {
                // 삭제
                // CRUD 의 D.
                self.container.viewContext.delete(data)
                print("삭제된 데이터: \(data)")
            }
            
            // 변경 사항 저장
            try self.container.viewContext.save()
            print("데이터 삭제 완료")
            
        } catch {
            print("데이터 삭제 실패: \(error)")
        }
    }
    
    // CoreData 저장된 데이터 전체 삭제
    func deleteAllData() {
        let fetchRequest = BookData.fetchRequest()

        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
                print("삭제된 데이터: \(data)")
            }
            
            try self.container.viewContext.save()
            print("모든 데이터 삭제 완료")
            
        } catch {
            print("모든 데이터 삭제 실패: \(error)")
        }
    }
    
    // CoreData 저장된 데이터 읽어오기
    func readAllData() -> [BookData] {
        do {
            let bookData = try self.container.viewContext.fetch(BookData.fetchRequest())
            return bookData

        } catch {
            print("데이터 읽기 실패")
            return []
        }
        
    }
    
    // 중복 검사
    func isBookExists(isbn: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BookData")
        request.predicate = NSPredicate(format: "isbn == %@", isbn)

        do {
            let count = try self.container.viewContext.count(for: request)
            return count > 0
        } catch {
            print("중복 확인 실패: \(error)")
            return false
        }
    }
}

