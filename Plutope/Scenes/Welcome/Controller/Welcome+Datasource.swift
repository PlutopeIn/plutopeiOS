//
//  Welcome+Datasource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 08/06/23.
//

import UIKit
import Lottie
import ImageIO

extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrWelcome.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvWelcomeViews.dequeueReusableCell(indexPath: indexPath) as WelcomeViewCell
        let data = arrWelcome[indexPath.row]
        
        cell.lblTitle.text = data.title
        cell.lblDescription.text = data.description
        
        if indexPath.row == 0 {
            cell.image.isHidden = false
            cell.animationView.isHidden = true
        } else {
            cell.image.isHidden = true
            cell.animationView.isHidden = false
        }
        
        cell.image.image = data.image
        cell.animationView.animation = LottieAnimation.named(data.animation)
        cell.animationView.loopMode = .loop
        cell.animationView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: screenWidth, height: clvWelcomeViews.bounds.height)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = self.clvWelcomeViews.frame.size.width
        self.pageControl.currentPage = Int(self.clvWelcomeViews.contentOffset.x / width)
        if pageControl.currentPage == arrWelcome.count - 1 {
            lblNext.isHidden = false
            viewNext.isHidden = false
        } else {
            lblNext.isHidden = true
            viewNext.isHidden = true
        }
    }

    /// Play animation when view will be scrolled
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let animatedCell = cell as? WelcomeViewCell {
            let animationView = animatedCell.animationView
            animationView?.play()
            print("DEBUG: PLAY ANIMATION \(animatedCell.lblTitle.text ?? "")")
        }
    }
    
    /// Stop animation when view will be scrolled
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let animatedCell = cell as? WelcomeViewCell {
            let animationView = animatedCell.animationView
            animationView?.stop()
            print("DEBUG: STOP ANIMATION \(animatedCell.lblTitle.text ?? "")")
        }
    }

}
