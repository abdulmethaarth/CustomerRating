//
//  WelcomeViewController.swift
//  Customer Rating
//
//  Created by Admin on 21/07/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func startBtnAction(_ sender: UIButton){
        let storyboard = mainStoryBoard
        let questionVC = (storyboard?.instantiateViewController(withIdentifier: "QuestionViewController")) as! QuestionViewController
        self.navigationController?.pushViewController(questionVC, animated: true)
    }
}

extension UIViewController{
    var mainStoryBoard: UIStoryboard?{
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
