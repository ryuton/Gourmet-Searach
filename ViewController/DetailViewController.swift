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
    var shopView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return  50
        case 1:
            return  275
        case 2:
            return  35
        case 3:
            return  35
        case 4:
            return   40
        default:
            break
        }
        return 100
    }
    
    //セルに表示する内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = self.rest?.name
        case 1:
            cell.imageView?.image = getImageByUrl(url: self.rest?.image_url.shop_image1)
        //cell.textLabel?.text = self.rest?.address
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
    
    func getImageByUrl(url: String?) -> UIImage{
        if let url = URL(string: url!) {
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)!
            } catch let err {
                print("Error : \(err.localizedDescription)")
            }
        }
        return UIImage(named: "pin")!
    }
}
