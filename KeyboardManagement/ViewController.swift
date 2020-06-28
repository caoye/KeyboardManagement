//
//  ViewController.swift
//  KeyboardManagement
//
//  Created by caoye on 2020/5/23.
//  Copyright © 2020 caoye. All rights reserved.
//

import UIKit

let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {

    var collection:UICollectionView?
    var dataArray: Array<Any> = []
    var sizeArray: Array<CGSize> = []
    var identiferArray: Array<String> = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        KeyboardManager.shared.isEnabled = true

        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenW, height: 100)
        
        self.collection = UICollectionView(frame: CGRect(x: 0, y: 0, width:screenW , height: screenH), collectionViewLayout: layout)
        self.collection?.register(HeaderCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(HeaderCollectionCell.self));

        self.collection?.delegate = self
        self.collection?.dataSource = self
        self.collection?.backgroundColor = .white

        self.view.addSubview(self.collection!)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.collection?.endEditing(true)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = NSStringFromClass(HeaderCollectionCell.self)
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let one: ViewControllerOne = ViewControllerOne()
        self.navigationController?.pushViewController(one, animated: true)
    }
}

