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
    var trailsArray = [TMTrails]()

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Trails"

        self.tblAllTrails.tableFooterView = UIView()

        //Make call to get all trail list from server
        self.callToGetAllTrailsFromServer()
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
        return 100 // This will be going to change as per design requirement
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trailsArray.count
    }

    // This method will enlist all the available trails
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trailCell = tableView.dequeueReusableCell(withIdentifier: "TMTrailsListTableViewCell", for: indexPath) as! TMTrailsListTableViewCell

        let trail = self.trailsArray[indexPath.row]

        trailCell.lblTrailName.text = trail.name
        trailCell.lblTrailShortNote.text = trail.guid // This for debug purpose will replace with any other attribute.

        return trailCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Selection code if user selects any trails
//        self.performSegue(withIdentifier: TMConstants.kSegueTrailSection, sender: self)
        self.performSegue(withIdentifier: TMConstants.kSegueCreateTrailSection, sender: self)
    }


    // Web service wrapper call to fetch trails from server instance
    func callToGetAllTrailsFromServer(){

        let reqstParams:[String:Any] = ["":""]

        TMWebServiceWrapper.getTrailsFromServer(KMethodType:.kTypePOST, APIName: TMConstants.kWS_GET_TRAILS, Parameters: reqstParams, onSuccess: { (response) in

            let trailsModel = response as! TMTrailsModel

            if ((trailsModel.trails?.count) ?? 0) > 0 {
                self.trailsArray = trailsModel.trails ?? []
                self.syncTrailsDataWithLocalDB(trailsArray: self.trailsArray)
                self.tblAllTrails.reloadData()
            }else {
                AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message: "Any failure message", PositiveTitle: TMConstants.kAlertTypeOK)
            }

        }) { (error) in
            AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message: error.debugDescription, PositiveTitle: TMConstants.kAlertTypeOK)
        }
    }

    //To Sync trails data with local SQLite database
    func syncTrailsDataWithLocalDB(trailsArray:[TMTrails]) {
        for trail in trailsArray {
            TMDataWrapperManager.sharedInstance.saveTrailToLocalDatabase(trailModel: trail)
        }
    }

}

// UITableview cell class for listings of Trails
class TMTrailsListTableViewCell: UITableViewCell {

    @IBOutlet weak var trailIconImageView: UIImageView!
    @IBOutlet weak var lblTrailName: UILabel!
    @IBOutlet weak var lblTrailShortNote: UILabel!

}
