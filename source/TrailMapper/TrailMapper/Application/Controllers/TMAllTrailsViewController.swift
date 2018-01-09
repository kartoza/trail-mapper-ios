//
//  TMAllTrailsViewController.swift
//  TrailMapper
//
//  Created by Netwin on 09/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit

class TMAllTrailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- IBOutlets
    @IBOutlet weak var tblAllTrails: UITableView!

    //MARK:- Variables & Constants


    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblAllTrails.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK:- UITableview Delegates & DataSources

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // Replace 5 with the acutal number of trails which we get from trails API
    }

    // This method will enlist all the available trails
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trailCell = tableView.dequeueReusableCell(withIdentifier: "TMTrailsListTableViewCell", for: indexPath) as! TMTrailsListTableViewCell

        trailCell.lblTrailName.text = " Trail \(indexPath.row + 1)"
        trailCell.lblTrailShortNote.text = " Trail \(indexPath.row + 1) short note"

        return trailCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Selection code if user selects any trails
    }

}

// UITableview cell class for listings of Trails
class TMTrailsListTableViewCell: UITableViewCell {

    @IBOutlet weak var trailIconImageView: UIImageView!
    @IBOutlet weak var lblTrailName: UILabel!
    @IBOutlet weak var lblTrailShortNote: UILabel!

}
