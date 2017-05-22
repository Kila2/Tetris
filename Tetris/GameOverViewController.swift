//
//  GameOverViewController.swift
//  Tetris
//
//  Created by junlianglee on 2017/5/18.
//  Copyright © 2017年 kila. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismiss(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) { 
            self.view.alpha = 0
        }
    }
    @IBAction func show(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 0.8
        }
    }
    
    @IBAction func goToAppleStore(_ sender: UIButton) {
        let appid = 12345
        let url = URL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(appid)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func restart(_ sender: UIButton) {
        self.dismiss(animated: true) { 
            GameViewController.restart()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
