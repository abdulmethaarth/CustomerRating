//
//  ThanksViewController.swift
//  Customer Rating
//
//  Created by Admin on 21/07/22.
//

import UIKit

class ThanksViewController: UIViewController {
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { [weak self] tmr in
            self?.navigationController?.popToRootViewController(animated: false)
        })
        SessionHelper.clearCurrentSession()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
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
