//
//  CountryCell.swift
//  CountryTask
//
//  Created by Eslam on 18/01/2025.
//

import UIKit
import SkeletonView

class CountryCell: UICollectionViewCell {

    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var countryImg: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    
    var animated = 0
    var selectedIndex:(()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        showAnimatedSkeleton()
    }

    func hideSkeletonView() {
        hideSkeleton()
    }
    
    @IBAction func favBtnPressed(_ sender: Any) {

        if animated == 0 {
            self.favBtn.setImage(UIImage(named: "icon-heart"), for: .normal)
            self.animated = 1
            
            selectedIndex?()
        } else {
            self.animated = 0
            self.favBtn.setImage(UIImage(named: "icon-heart-unfill"), for: .normal)
            
            selectedIndex?()
        }
    }
}

extension CountryCell: CountriesListCellView {
    func img(img: String) {
        ImageShowing().showImage(imgURl:img , imgView: countryImg, avatar: "imageAvatar")
    }
    
    func name(name: String) {
        self.countryNameLbl.text = name
    }
    
    func setFavoriteImage(name: String) {
        self.favBtn.setImage(UIImage(named: name), for: .normal)
    }
    
}
