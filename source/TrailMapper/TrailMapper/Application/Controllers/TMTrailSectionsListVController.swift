//
//  TMTrailSectionsListVController.swift
//  TrailMapper
//
//  Created by Netwin on 10/01/18.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit

    class TMTrailSectionsListVController: UIViewController,UITableViewDelegate,UITableViewDataSource {

        //MARK:- IBOutlets
        @IBOutlet weak var tblAllTrailSections: UITableView!

        //MARK:- Variables & Constants
        var trailSectionArray = [TMTrailSections]()

        //MARK:- View LifeCycle
        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            self.title = "Trail Section"

            self.tblAllTrailSections.tableFooterView = UIView()

            //Make call to get all trail section list from server
            self.callToGetAllTrailSectionsFromServer()
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
            return self.trailSectionArray.count
        }

        // This method will enlist all the available trail sections
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let trailCell = tableView.dequeueReusableCell(withIdentifier: "TMTrailSectionListTableViewCell", for: indexPath) as! TMTrailSectionListTableViewCell

            let trailSection = self.trailSectionArray[indexPath.row]

            trailCell.lblTrailSectionName.text = trailSection.name
            trailCell.lblTrailSectionShortNote.text = trailSection.guid // This for debug purpose will replace with any other attribute.

            return trailCell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Selection code if user selects any trail section
        }


        // Web service wrapper call to fetch trail sections from server instance
        func callToGetAllTrailSectionsFromServer(){

            let reqstParams:[String:Any] = ["":""]

            TMWebServiceWrapper.getTrailSectionsFromServer(KMethodType:.kTypePOST, APIName: TMConstants.kWS_GET_TRAIL_SECTIONS, Parameters: reqstParams, onSuccess: { (response) in

                let trailSectionModel = response as! TMTrailSectionModel

                if ((trailSectionModel.trailSections?.count) ?? 0) > 0 {
                    self.trailSectionArray = trailSectionModel.trailSections ?? []
                    //self.syncTrailsDataWithLocalDB(trailsArray: self.trailsArray)
                    self.tblAllTrailSections.reloadData()
                }else {
                    AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message: "Any failure message", PositiveTitle: TMConstants.kAlertTypeOK)
                }

            }) { (error) in
                AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message: error.debugDescription, PositiveTitle: TMConstants.kAlertTypeOK)
            }
        }

        //To Sync trail section data with local SQLite database
        func syncTrailSectionDataWithLocalDB(trailSectionsArray:[TMTrailSections]) {
            for trailSection in trailSectionsArray {
                TMDataWrapperManager.sharedInstance.saveTrailSectionsToLocalDatabase(trailSectionModel: trailSection)
            }
        }
}

// UITableview cell class for listings of Trails
class TMTrailSectionListTableViewCell: UITableViewCell {

    @IBOutlet weak var trailSectionIconImageView: UIImageView!
    @IBOutlet weak var lblTrailSectionName: UILabel!
    @IBOutlet weak var lblTrailSectionShortNote: UILabel!

}
