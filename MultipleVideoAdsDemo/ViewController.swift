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
    var adLoadersToAds: [GADAdLoader: GADCustomNativeAd?] = [:]
    var adLoaders: [GADAdLoader] = []
    let numberOfCell = 3
    
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
        loadMultipleVideoAds()
    }

    func loadMultipleVideoAds() {
        for _ in stride(from: 0, to: numberOfCell, by: 2) {
            let adLoader = GADAdLoader(adUnitID: TestAdUnit,
                                       rootViewController: self,
                                       adTypes: [.customNative],
                                       options:nil)
            adLoader.delegate = self
            adLoader.load(GAMRequest())
            adLoaders.append(adLoader)
        }
        
    }
    
    public func enableAutomaticCellSize() {
         if let flowLayout = myCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
             flowLayout.estimatedItemSize = getCardViewEstimatedItemSize()
         }
     }

     private func getCardViewEstimatedItemSize() -> CGSize {
         let screenWidth = UIScreen.main.bounds.width
         return CGSize(width: screenWidth - 40, height: screenWidth)

     }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoAdsCollectionViewCell", for: indexPath) as? VideoAdsCollectionViewCell {
            cell.backgroundColor = UIColor.blue
            let adLoaderIndex = indexPath.item/2
            let adLoader = adLoaders[adLoaderIndex]
            let customNativeAd = adLoadersToAds[adLoader] as? GADCustomNativeAd
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
        adLoadersToAds[adLoader] = customNativeAd
        customNativeAd.recordImpression()
        myCollectionView?.reloadData()
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
