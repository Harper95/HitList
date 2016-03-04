//
//  ViewController.swift
//  HitList
//
//  Created by Clayton Harper on 3/4/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	
	var people = [NSManagedObject]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "\"The List\""
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "Person")
		
		do {
			let results = try managedContext.executeFetchRequest(fetchRequest)
			people = results as! [NSManagedObject]
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return people.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
		
		let person = people[indexPath.row]
		
		cell!.textLabel!.text = person.valueForKey("name") as? String
		
		return cell!
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func saveName(name: String) {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
		let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
		
		person.setValue(name, forKey: "name")
		do {
			try managedContext.save()
			people.append(person)
		} catch let error as NSError {
			print("Could not save \(error), \(error.userInfo)")
		}
	}

	@IBAction func addName(sender: AnyObject) {
		let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .Alert)
		
		let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction) in
			let textFeild = alert.textFields!.first
			self.saveName(textFeild!.text!)
			self.tableView.reloadData()
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
		
		alert.addTextFieldWithConfigurationHandler(nil)
		
		alert.addAction(saveAction)
		alert.addAction(cancelAction)
		
		presentViewController(alert, animated: true, completion: nil)
	}

}

