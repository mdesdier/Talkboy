//
//  TalkTableViewController.swift
//  TalkBoy
//
//  Created by tester on 11/19/18.
//  Copyright © 2018 Tepo Labs. All rights reserved.
//

import UIKit
import AVFoundation

class TalkTableViewController: UITableViewController {

    var sounds : [Sound] = []
    var audioPlayer : AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

   // override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    //    return 0
   // }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sounds.count
    }

    //added since we want to get items (sounds) into cells when view ill appear
    override func viewWillAppear(_ animated: Bool) {
        getSounds()
    }
    
    func getSounds() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let tempSounds = try? context.fetch(Sound.fetchRequest()) as? [Sound] {
                if let theSounds = tempSounds { //unwarpping
                    sounds = theSounds
                    tableView.reloadData()
                }
            }
        }
    }
    
    
    //uncommented this one so we can put stuff in the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            //+++marcel, reuseIdentifier has to be plugged in storyboard->table view cell->identifier
        
        // Configure the cell...
        let sound = sounds[indexPath.row] //get sound item from array and add to this cell
        cell.textLabel?.text = sound.name
        
        return cell
    }
    
    //+++add this one for when someone taps on our cell/row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row] //get sound item from array and add to this cell
        if let audioData = sound.audioData { //unwrap
            audioPlayer = try? AVAudioPlayer(data: audioData)
            audioPlayer?.play()
        }
        tableView.deselectRow(at: indexPath, animated: true) //we deselect row to remove gray background
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let sound = sounds[indexPath.row]
                context.delete(sound)
                getSounds() //get sounds from core data into our local array so the deleted item is gone from array too.  BTW getSounds does a reloadData so no need to add another here.
                
            }
            print("ask to delete")
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

   

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
