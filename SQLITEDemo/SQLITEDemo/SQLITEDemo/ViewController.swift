//
//  ViewController.swift
//  SQLITEDemo
//
//  Created by Esraa Hassan on 5/31/19.
//  Copyright © 2019 Esraa And Passant. All rights reserved.
//

import UIKit
import SQLite3
import Foundation

class ViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    let myPath = "‎⁨Part1.sqlite"
    let createTableString = """
    CREATE TABLE Friend(
    Phone INT PRIMARY KEY NOT NULL,
    Name CHAR(255),Age INT);
    """
    var db: OpaquePointer? = nil
    var phoneArray = [Int32]()
    var nameArray = [String]()
    var ageArray = [Int32]()
    override func viewDidLoad() {
        super.viewDidLoad()
        destroyDatabase()
        db = openDatabase()
        createTable()
        insert(name: "esraa",phone: 0112,age: 23)
        insert(name: "nouran",phone: 010,age: 21)
        query()
        sqlite3_close(db)

        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
    }
    
    
    func destroyDatabase(){
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: myPath))
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
    }
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("HeroesDatabase.sqlite")
        
        
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(myPath)")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
            self.dismiss(animated: true, completion: nil)
        }
        return db
    }
    func createTable() {
        var createTableStatement: OpaquePointer? = nil
        
        //kda al createTableStatment de d5la fdya mfehash hagaa mn no3 opaquepointer w awl ma al method de ttnfz w yl2e db w create statment sah by7ut al nateg al bytecode bt3hum f al createTableStatment de
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK { //
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Friend table created.")
            } else {
                print("Friend table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
      
        sqlite3_finalize(createTableStatement)
        //You must always call sqlite3_finalize() on your compiled statement to delete it and avoid resource leaks. Once a statement has been finalized, you should never use it again.
    }
    func insert(name : String , phone : Int32 , age : Int32) {
        var insertStatement: OpaquePointer? = nil
        let insertStatementString = "INSERT INTO Friend(phone, Name, Age) VALUES (?, ?, ?);"
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            ////////////////first Friend////////////////////
            var name: NSString = name as NSString
            sqlite3_bind_int(insertStatement, 1, phone)
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil) // int
            sqlite3_bind_int(insertStatement, 3, age)
            
            
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    // B-
    func query() {
        let queryStatementString = "SELECT * FROM Friend;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while(sqlite3_step(queryStatement) == SQLITE_ROW ){
                let phone = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                let age = sqlite3_column_int(queryStatement, 2)
                phoneArray.append(phone)
                nameArray.append(name)
                ageArray.append(age)
                print("Query Result:")
                print("\(phone) | \(name) | \(age)")
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
    }
    func delete(phone : Int32) {
        var deleteStatement: OpaquePointer? = nil
        let deleteStatementStirng = "DELETE FROM Friend WHERE Phone = \(phone);"
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared") // Handling Errors // Try to change the table name :)
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
        
        sqlite3_finalize(deleteStatement)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableViewCell
        cell.friendName.text = "Name: "+nameArray[indexPath.row]
        cell.friendAge.text = "Phone: "+String(ageArray[indexPath.row])
        cell.friendPhone.text = "Age: "+String(phoneArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(phone: phoneArray[indexPath.row])
            self.nameArray.remove(at: indexPath.row)
            self.ageArray.remove(at: indexPath.row)
            self.phoneArray.remove(at: indexPath.row)
            
            self.myTableView.deleteRows(at: [indexPath], with: .automatic)
            self.myTableView.reloadData()
        }
    }
    
}

