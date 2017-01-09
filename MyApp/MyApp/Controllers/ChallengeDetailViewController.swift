//
//  FollowViewController.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/14/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit

class ChallengeDetailViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containResponseView: UIView!
    @IBOutlet weak var containChallengeView: UIView!
    
    var challengeView: ChallengeView!
    var responseView: ResponseView!
    
    @IBOutlet weak var heightChallengeConstant: NSLayoutConstraint!
    @IBOutlet weak var heightResponseConstraint: NSLayoutConstraint!
    
    var challenge:Challenge!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - ui
    func updateUI(){
        if(responseView == nil){
            if let aNewFeed = UIView.loadFromNibNamed("ResponseView") as? ResponseView{
                self.responseView = aNewFeed
                self.responseView.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        self.containResponseView.addSubview(self.responseView)
        if (challengeView == nil){
            if let aChallengeView = UIView.loadFromNibNamed("ChallengeView") as? ChallengeView{
                self.challengeView = aChallengeView
                
                self.challengeView.isDetailView = true
                self.challengeView.translatesAutoresizingMaskIntoConstraints = false
                
            }
        }
        self.challengeView.challenge = challenge
        self.containChallengeView.addSubview(self.challengeView)
        
    }
    
    //MARK - UITableViewDelegate, UITableViewDatasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeDetailTableViewCellID", for: indexPath) as! ChallengeDetailTableViewCell
        return cell
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }


}
