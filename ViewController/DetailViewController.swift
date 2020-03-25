//
//  DetailViewController.swift
//  FenrirGourmet
//
//  Created by 上野隆斗 on 2020/03/26.
//  Copyright © 2020 ryuton. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var rest: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = self.rest?.name
        case 1:
            cell.textLabel?.text = self.rest?.address
        case 2:
            cell.textLabel?.text = self.rest?.tel
        case 3:
            cell.textLabel?.text = self.rest?.opentime
        case 4:
            cell.textLabel?.text = self.rest?.image_url.shop_image1
        default:
            break
        }
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
