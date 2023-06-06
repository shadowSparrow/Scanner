//
//  ScanDetailViewController.swift
//  Scanner
//
//  Created by mac on 07.06.2023.
//

import UIKit

class ScanDetailViewController: UIViewController {

    var detailView: DetailView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let navigationVC = UINavigationController(rootViewController: self)
        
         detailView = DetailView()
        detailView.frame = self.view.frame
        self.view.addSubview(detailView)
        // Do any additional setup after loading the view.
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
