//
//  TableTableViewController.swift
//  MathTouch_Unified
//
//  Created by Rayan Tejuja on 4/27/18.
//  Copyright © 2018 B22. All rights reserved.
//

import UIKit
import SQLite





class TableTableViewController: UITableViewController{

    
    @IBOutlet var LatexTableView: UITableView!
    
    //Database, Table and its columns
    let id = Expression<Int64>("id")
    let equation = Expression<String>("equation")
    let SavedEquationsTable = Table("SavedEquations")
    var database : Connection!
    
    var equations = [String]()
    var myIndex = 0
    var equationToReturn = String()

    override func loadView() {
        super.loadView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        LatexTableView.delegate = self
        LatexTableView.dataSource = self
        LatexTableView.isUserInteractionEnabled = true
        
        do{
            //Get the location of the Databse Directory, the UseData databse and connect
            let documentDirectory = try FileManager.default.url(for : .documentDirectory, in: .userDomainMask,appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("UserData").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch {
            print("Error while connecting to DB : " + error.localizedDescription)
        }
        
        do {
            
            for eq in try database.prepare(SavedEquationsTable)
            {
                self.equations.append(eq[equation])
            }
        }
        catch {
            print("Error slecting from table : " + error.localizedDescription)
        }
        
        
        
//        LatexTableView.translatesAutoresizingMaskIntoConstraints = false
    
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
//    override func viewDidAppear(_ animated: Bool) {
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.equations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        print("adding \(self.equations[indexPath.row]) to the table")
        let cell = tableView.dequeueReusableCell(withIdentifier: "LatexCell") as! TableViewLatexCell
//        cell.LatexCellViewLabel.text = self.equations[indexPath.row]
        
//        YIndex = 0
        let label: MTMathUILabel = MTMathUILabel(frame: CGRect(x: 30, y: 0, width: Int(floor( self.view.frame.size.width)), height: 40))
        label.latex = self.equations[indexPath.row]
        label.latex = preprocessLatexString(label.latex!)
        label.fontSize = 15
        label.backgroundColor = UIColor.white
//        label.textAlignment = MTTextAlignment.Center
        cell.insertSubview(label, at: indexPath.row)
        cell.bringSubview(toFront: label)
        
        return cell
    }
    
    func preprocessLatexString(_ latexInput: String)-> String{
        var result = latexInput.replacingOccurrences(of: "\\dfrac", with: "\\frac")
        return result
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        equationToReturn = equations[indexPath.row]
        //performSegue(withIdentifier: "segue", sender: self)
    }
}
