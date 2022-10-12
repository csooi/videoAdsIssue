//
//  ViewController.swift
//  MultipleVideoAdsDemo
//
//  Created by Chien Shing Ooi on 14/09/2022.
//

import UIKit
import GoogleMobileAds

private let TestAdUnit = "/6499/example/native-video"
private let testNativeCustomFormatID = "10104090"

class ViewController: UIViewController {

    var myCollectionView: UICollectionView?
    var customNativeAd: GADCustomNativeAd?
    var adLoader: GADAdLoader?
    let numberOfCell = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.register(UINib(nibName: "VideoAdsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoAdsCollectionViewCell")
        myCollectionView?.register(UINib(nibName: "TextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TextCollectionViewCell")
        
        myCollectionView?.backgroundColor = UIColor.white
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        enableAutomaticCellSize()
        view.addSubview(myCollectionView ?? UICollectionView())
        self.view = view
        loadVideoAds()
    }

    func loadVideoAds() {
        adLoader = GADAdLoader(adUnitID: TestAdUnit,
                                   rootViewController: self,
                                   adTypes: [.customNative],
                                   options:nil)
        adLoader?.delegate = self
        adLoader?.load(GAMRequest())
    }
    
    public func enableAutomaticCellSize() {
         if let flowLayout = myCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
             flowLayout.itemSize = getCardViewEstimatedItemSize()
         }
     }

     private func getCardViewEstimatedItemSize() -> CGSize {
         let screenWidth = UIScreen.main.bounds.width
         return CGSize(width: screenWidth, height: screenWidth * 0.8)

     }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoAdsCollectionViewCell", for: indexPath) as? VideoAdsCollectionViewCell {
            cell.populate(withCustomNativeAd: customNativeAd)
            return cell
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCollectionViewCell", for: indexPath) as? TextCollectionViewCell {
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
}

extension ViewController: GADCustomNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive customNativeAd: GADCustomNativeAd) {
        print("Received custom native ad: \(customNativeAd)")
        self.customNativeAd = customNativeAd
        customNativeAd.recordImpression()
        myCollectionView?.reloadData()
        myCollectionView?.setNeedsDisplay()
    }

    func customNativeAdFormatIDs(for adLoader: GADAdLoader) -> [String] {
        return [testNativeCustomFormatID]
    }
}

extension ViewController: GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}
