//
//  ViewController.swift
//  MilestoneProject4-6
//
//  Created by Adnann Muratovic on 23/12/2020.
//  Copyright © 2020 Adnann Muratovic. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	//MARK: Properties
	var items = [String]()
	var item = [Item]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
		
//		navigationItem.leftBarButtonItem = editButtonItem
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
	
		title = "Shopping List"
		
		let defaults = UserDefaults.standard
		if let savedItem = defaults.object(forKey: "item") as? Data {
			let jsonDecoder = JSONDecoder()
			
			do {
				items = try jsonDecoder.decode([String].self, from: savedItem)
			}
			catch {
				print("Fail to load Items..")
			}
		}

		
	}
	
	@objc private func shareTapped() {
		//There’s a special method that can create one string from an array, by stitching each part together using a separator you provide.
		let list = items.joined(separator: "\n")
		
		let ac = UIActivityViewController(activityItems: [list], applicationActivities: [])
		ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
		present(ac, animated: true)
	}
	
//	@objc private func deleteItem() {
//		items.remove(at: 0)
//		tableView.reloadData()
//	}
	
	@objc private func addItem() {
		let ac = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		let submitItem = UIAlertAction(title: "OK", style: .default) {
			[weak self, weak ac] _ in
			guard let takeItem = ac?.textFields?[0].text else { return }
			self?.submit(takeItem)
		}
		
		ac.addAction(submitItem)
		present(ac, animated: true)
	}
	
	private func submit(_ action: String) {
		items.insert(action, at: 0)
		let indexPath = IndexPath(row: 0, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}
	
	// MARK: TableView
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// Date and Time
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .short
		dateFormatter.locale = Locale.current
		let date = NSDate()
	
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = items[indexPath.row]
		cell.detailTextLabel?.text = dateFormatter.string(from: date as Date)
		save()
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			items.remove(at: 0)
			tableView.reloadData()
		}
	}
	
	func save() {
		let jsonEncoder = JSONEncoder()
		if let savedData = try? jsonEncoder.encode(items) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: "item")
		} else {
			print("Failed to save Item")
		}
	}
}



