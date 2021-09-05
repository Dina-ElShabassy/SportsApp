//
//  SportsViewController.swift
//  SportsApp
//
//  Created by iOS Training on 2/16/21.
//  Copyright © 2021 iOS Training. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class SportsViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate {
    
    var cell=CollectionViewCell()
    var sportsArray = [Sports]()
    

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        
        getSportsData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return sportsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell

        
        cell.sportImage.sd_setImageWithURL(NSURL(string: sportsArray[indexPath.row].sport_image))
       
        cell.sportName.text=sportsArray[indexPath.row].sport_name
        
        return cell;
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueID"
        {
            
            let leagueVC : LeaguesViewController = (segue.destinationViewController as? LeaguesViewController)!
            
            let selectedIndex = self.myCollectionView.indexPathForCell(sender as! UICollectionViewCell)
            
            leagueVC.sportSelected = sportsArray[(selectedIndex?.row)!].sport_name
            
        }
        
    }
    
    
    
    func getSportsData() {
        
        Alamofire.request(.GET, "https://www.thesportsdb.com/api/v1/json/1/all_sports.php")
            .responseJSON(completionHandler:{ _,_,response in
                
                if response.isSuccess{
                    
                    let json=response.value as! [String : AnyObject]
                    
                    var sportArr = json["sports"] as! [AnyObject]
                    
                    for i in 0..<sportArr.count{
                        
                        let sport_obj = Sports ()
                        let sportDict  = sportArr[i]

                        sport_obj.sport_image = sportDict["strSportThumb"] as! String
                        sport_obj.sport_name = sportDict["strSport"] as! String
                        
                        self.sportsArray.append(sport_obj)
                        
                    }
                    
                }
                
                self.myCollectionView.reloadData()
            
        })
        
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
   */
    

}

extension SportsViewController : UICollectionViewDelegateFlowLayout{
    
    @objc(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width  = (myCollectionView.bounds.width)/2
        return CGSize(width: width, height: width)
    }
    
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:)
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
}




