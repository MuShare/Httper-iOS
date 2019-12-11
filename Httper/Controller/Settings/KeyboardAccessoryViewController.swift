//
//  KeyboardAccessoryViewController.swift
//  Httper
//
//  Created by Meng Li on 2019/11/14.
//  Copyright © 2019 MuShare. All rights reserved.
//

private struct Const {
    
    struct collection {
        static let marginTop = 2
        static func cellWidth(column: Int) -> CGFloat {
            (UIScreen.main.bounds.width - CGFloat(column - 1) * 1) / CGFloat(column)
        }
    }
    
}

class KeyboardAccessoryViewController: BaseViewController<KeyboardAccessoryViewModel> {
    
    private lazy var addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCharacter))

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: {
            let layout = UICollectionViewFlowLayout()
            let width = Const.collection.cellWidth(column: 4)
            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .vertical
            return layout
        }())
        collectionView.register(cellType: KeyboardAccessoryCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var dataSource = KeyboardAccessoryCollectionViewCell.collectionViewSingleSectionDataSource(configureCell: { cell, indexPath, _ in
        cell.didRemove = { [unowned self] in
            self.viewModel.remove(at: indexPath.row)
        }
    })

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = addBarButtonItem
        view.addSubview(collectionView)
        createConstraints()
        
        disposeBag ~ [
            viewModel.title ~> rx.title,
            viewModel.characterSection ~> collectionView.rx.items(dataSource: dataSource)
        ]
        
    }

    private func createConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeArea.top).offset(Const.collection.marginTop)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func addCharacter() {
        let alertController = UIAlertController(
            title: R.string.localizable.add_character(),
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField {
            $0.textAlignment = .center
        }
        let addAction = UIAlertAction(title: R.string.localizable.ok_name(), style: .default) { [unowned self] _ in
            self.viewModel.add(character: alertController.textFields?[0].text)
        }
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel_name(), style: .cancel)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}
