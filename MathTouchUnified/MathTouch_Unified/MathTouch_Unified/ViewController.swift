//
//  ViewController.swift
//  MathTouch_Unified
//
//  Created by GongYichen on 4/11/18.
//  Copyright © 2018 B22. All rights reserved.
//

import UIKit
import SwiftSocket
import SQLite
//import iosMath

class ViewController: UIViewController, NRFManagerDelegate {
    
    //global variables
    weak var editorViewController: EditorViewController!
    var equationInLatex: String!
    var previousEquation: String!
    var database : Connection!
    var nrfManager: NRFManager!
    var timeToSend: Bool!
    var passedLatexEqn = String()
    
    @IBOutlet weak var connectAndSendBottonItem: UIBarButtonItem!
    //Table and its columns
    let id = Expression<Int64>("id")
    let equation = Expression<String>("equation")
    let SavedEquationsTable = Table("SavedEquations")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        equationInLatex = String()
        previousEquation = String()
        
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
            try database.scalar(SavedEquationsTable.exists)
        } catch{
            //Table does not exist
            createAndPopulateTable(DB: database)
        }
       
        editorViewController = childViewControllers.first as! EditorViewController
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if (appDelegate.engine == nil)
            {
                let alert = UIAlertController(title: "Certificate error",
                                              message: appDelegate.engineErrorMessage,
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertActionStyle.default,
                                              handler: {(action: UIAlertAction) -> Void in
                                                exit(1)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            editorViewController.engine = appDelegate.engine
        }
        
        editorViewController.inputMode = .forcePen
    
        do {
            if let package = try createPackage(packageName: "New") {
                try editorViewController.editor.part = package.getPartAt(0)
            }
        } catch {
            print("Error while creating package : " + error.localizedDescription)
        }
        
        
        nrfManager = NRFManager(
            onConnect: {
                self.log("C: ★ Connected")
                self.connectAndSendBottonItem.title = "Send"
                
        },
            onDisconnect: {
                self.log("C: ★ Disconnected")
                self.connectAndSendBottonItem.title = "Connect to Device"
                
        },
            onData: {
                (data:Data?, string:String?)->() in
                self.log("C: ⬇ Received data - String: \(String(describing: string)) - Data: \(String(describing: data))")
        },
            autoConnect: false
        )
        
        nrfManager.verbose = true
        nrfManager.delegate = self
        
    }
    
    
    
    func createPackage(packageName: String) throws -> IINKContentPackage? {
        // Create a new content package with name
        var resultPackage: IINKContentPackage?
        let fullPath = FileManager.default.pathForFile(inDocumentDirectory: packageName) + ".iink"
        if let engine = (UIApplication.shared.delegate as? AppDelegate)?.engine {
            resultPackage = try engine.createPackage(fullPath.decomposedStringWithCanonicalMapping)
            
            // Add a blank page type Text Document
            if let part = try resultPackage?.createPart("Math") /* Options are : "Diagram", "Drawing", "Math", "Text Document", "Text" */ {
                self.title = "Type: " + part.type
                
            }
        }
        return resultPackage
    }
    
    
    
    //Button Presses
    
    @IBAction func connectAndSendBotton(_ sender: Any) {
        if self.nrfManager.connectionStatus == .connected {

            self.convertAndSend(equationInLatex)

        } else{
            self.nrfManager.connect()
        }
    }
    @IBAction func UndoButtonWasTouchedUpInside(_ sender: UIBarButtonItem) {
        editorViewController.editor.undo()
        if !equationInLatex.isEmpty
        {
            previousEquation = equationInLatex
            equationInLatex = String()
        }
        else if !previousEquation.isEmpty
        {
            equationInLatex = previousEquation
            previousEquation = String()
        }
        
    }
    
    @IBAction func RedoButtonWasTouchedUpInside(_ sender: UIBarButtonItem) {
        editorViewController.editor.redo();
        if !previousEquation.isEmpty
        {
            equationInLatex = previousEquation
            previousEquation = String()
        }
    }
    
    @IBAction func DeleteButtonWasTouchedUpInside(_ sender: UIBarButtonItem) {
        editorViewController.editor.clear();
        previousEquation = equationInLatex
        equationInLatex = String()
    }
    @IBAction func ConvertButtonWasTouchedUpInside(_ sender: UIBarButtonItem) {
        do {
            editorViewController.editor.waitForIdle()
            let supportedTargetStates = editorViewController.editor.getSupportedTargetConversionState(nil)
            try editorViewController.editor.convert(nil, targetState: supportedTargetStates[0].value)
        } catch {
            print("Error while converting : " + error.localizedDescription)
        }
        do
        {
            try equationInLatex = editorViewController.editor.export_(nil, mimeType: .laTeX)
        }
        catch
        {
            print("Error while printing : " + error.localizedDescription)
        }
        print(equationInLatex)
        previousEquation = String()
    }
    
    @IBAction func SaveButtonWasTouchedUpInside(_ sender: UIBarButtonItem) {
        if equationInLatex.isEmpty
        {
            let alert = UIAlertController(title: "Unable to save",
                                          message: "Please draw an equation to save",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertActionStyle.default,
                                          handler: {(action: UIAlertAction) -> Void in
                                            return
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        do{
           try database.run(SavedEquationsTable.insert(equation <- equationInLatex))
            
            
        }
        catch
        {
            let alert = UIAlertController(title: "Unable to save",
                                          message: "This equation is already saved",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertActionStyle.default,
                                          handler: {(action: UIAlertAction) -> Void in
                                            return
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "Successfully Saved",
                                      message: "",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: UIAlertActionStyle.default,
                                      handler: {(action: UIAlertAction) -> Void in
                                        return
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue)
    {
        guard let tableView = sender.source as? TableTableViewController else {
            return
        }
        equationInLatex = tableView.equationToReturn
        
        do {
            try editorViewController.editor.import_(.laTeX, data: tableView.equationToReturn, block: nil)
            editorViewController.editor.waitForIdle()
            let supportedTargetStates = editorViewController.editor.getSupportedTargetConversionState(nil)
            try editorViewController.editor.convert(nil, targetState: supportedTargetStates[0].value)
        } catch {
            print("Error while converting : " + error.localizedDescription)
        }
    }
    
    //General Functions
    
    func createAndPopulateTable(DB: Connection)
    {
        do{
            try DB.run(SavedEquationsTable.create { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(equation, unique: true)
            })
            
        }
        catch
        {
            print("Error while connecting to DB : " + error.localizedDescription)
        }
        
    }
    
    func onDataRecieved(latexEquation: String)
    {
        print("data Recieved")
    }
    
        
//        // Do any additional setup after loading the view, typically from a nib.
//        var latexEquations = Array<String>()
//        latexEquations.append("x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}")
//        latexEquations.append("\\forall x \\in X, \\quad \\exists y \\leq \\epsilon")
//        latexEquations.append("\\frac{n!}{k!(n-k)!} = \\binom{n}{k}")
//
//        print( self.view.frame.size.width)
//
//        var YIndex = 50
//        var index = 0
//
//        for latexEquation in latexEquations
//        {
//            let label: MTMathUILabel = MTMathUILabel(frame: CGRect(x: 0, y: YIndex, width: Int(floor( self.view.frame.size.width)), height: 100))
//            label.latex = latexEquation
//            label.fontSize = 30
//            label.backgroundColor = UIColor.white
//            label.textAlignment = MTTextAlignment.center
//
//            self.view.insertSubview(label, at: index)
//            self.view.bringSubview(toFront:label)
//
//            YIndex += 100
//            index += 1
//        }
        

//        for latexEquation in latexEquations {
//            let client = TCPClient(address: "172.16.45.222", port: 8989)
//            switch client.connect(timeout: 10000) {
//            case .success:
//                switch client.send(string: latexEquation ) {
//                case .success:
//                    guard let data = client.read(1024*10, timeout:10000) else { break }
//                    if let response = String(bytes: data, encoding: .utf8) {
//                        print(latexEquation)
//                        print(response)
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            case .failure(let error):
//                print(error)
//            }
//            client.close()
//        }
//
//    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.


}


extension ViewController
{
    func nrfDidConnect(_ nrfManager:NRFManager)
    {
        self.log("D: ★ Connected")
    }
    
    func nrfDidDisconnect(_ nrfManager:NRFManager)
    {
        self.log("D: ★ Disconnected")
    }
    
    func nrfReceivedData(_ nrfManager:NRFManager, data: Data?, string: String?) {
        self.log("D: ⬇ Received data - String: \(string) - Data: \(data)")
        if string == "*"{
            self.timeToSend = true
        }
    }
    
    func log(_ string:String)
    {
        print(string)
    }
    
    func sendInSegments(_ string:String) -> Bool{
        var seg = ""
        var result: Bool
        for i in 0 ... string.count{
            if i % 14 != 0 || i == 0{
                seg += string[i]
            }else{
                result = self.nrfManager.writeString(seg)
                seg = string[i]
            }
        }
        result = self.nrfManager.writeString(seg)
        return result
    }
    func sendEquation(_ equation: String){
        self.timeToSend = true
        let splits = equation.split(separator: "~")
        var count = 0
        for seg in splits{
            if (seg.count == 0){
                break
            }
            let equation_segment = seg + "~"
//            while(!self.timeToSend){
//                usleep(500)
//                print(self.timeToSend)
//            }
            if count != 0{
                usleep(2500000)
            }
            
            print(equation_segment)
            self.sendInSegments(String(equation_segment))
            self.timeToSend = false
            count += 1
        }
        self.timeToSend = true
        // split the segments with "~"
        // send the segment with --> sendInSegments
    }
    
    func convertAndSend(_ latexEquation: String){
        let client = TCPClient(address: "34.207.84.202", port: 8989)
        switch client.connect(timeout: 10000) {
        case .success:
            switch client.send(string: latexEquation ) {
            case .success:
                guard let data = client.read(1024*10, timeout:1000) else { break }
                if let response = String(bytes: data, encoding: .utf8) {
                    print(latexEquation)
                    print(response)
                    self.sendEquation(response)
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        client.close()
    }
}




// extention for the string class
extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
