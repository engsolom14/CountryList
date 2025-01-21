//
//  ImageShowing.swift
//  Digybite CaseStudy
//
//  Created by Eslam on 04/06/2023.
//

import Foundation
import UIKit
import SDWebImage
import SkeletonView

class ImageShowing {

    func showImage(imgURl: String, imgView: UIImageView, avatar: String) {
        let imageURL = URL(string: imgURl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" )
//        AMShimmer.start(for: imgView)
        imgView.showAnimatedSkeleton()
        imgView.sd_setImage(with: imageURL, completed: {
            (image, error, cacheType, url) in
            if error != nil {
                imgView.image = UIImage(named: avatar)
            }
//            AMShimmer.stop(for: imgView)
            imgView.hideSkeleton()
//            imgView.stopSkeletonAnimation()
        })

    }

}
