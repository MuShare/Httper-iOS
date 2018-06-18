//
//  KeyboardAccessoryCollectionViewController.swift
//  Httper
//
//  Created by lidaye on 11/08/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit

class KeyboardAccessoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let user = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / CGFloat(4)
        return CGSize(width: width, height: width)
    }

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (user.characters?.count)! + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row == user.characters?.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "addCharacterCell", for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath)
        let characterLabel = cell.viewWithTag(1) as! UILabel
        characterLabel.text = user.characters?[indexPath.row]
        return cell
        
    }
    
    // MARK: - Action
    
    @IBAction func addCharacter(_ sender: Any) {
        let alertController = UIAlertController(title: R.string.localizable.add_character(),
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.textAlignment = .center
        }
        let addAction = UIAlertAction(title: R.string.localizable.ok_name(), style: .default, handler: { (action) in
            let character = (alertController.textFields?[0].text)!
            if character != "" {
                self.user.characters?.append(character)
                self.collectionView?.reloadData()
            }
        })
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel_name(), style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func removeCharacter(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UICollectionViewCell
        let indexPath = collectionView?.indexPath(for: cell)
        user.characters?.remove(at: (indexPath?.row)!)
        collectionView?.deleteItems(at: [indexPath!])
    }
    
}
