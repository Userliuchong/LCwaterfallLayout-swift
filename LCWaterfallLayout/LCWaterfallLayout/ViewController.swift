//
//  ViewController.swift
//  LCWaterfallLayout
//
//  Created by 刘崇 on 17/3/13.
//  Copyright © 2017年 liuchong. All rights reserved.
//

import UIKit

class ViewController: UIViewController,LCWaterfallLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let lceat = LCWaterfallLayout()
        lceat.waterdelegate = self
        lceat.setColumnSpacing(columnspacing: 10, rowspacing: 10, sectionInset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        //实现网格
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: lceat)
        collection.delegate = self
        collection.dataSource = self
        self.view.addSubview(collection)
        //注册单元格
        collection.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "MyCell")
    }
    //
    func lcwaterfallLayout(waterfallLayout: LCWaterfallLayout, itemwidth: CGFloat, atindexpath: NSIndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(150))/CGFloat(70) * itemwidth
    }
    //行数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60;
    }
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionC = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        collectionC.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        return collectionC;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

