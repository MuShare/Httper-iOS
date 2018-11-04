//
//  ProjectViewController.swift
//  Httper
//
//  Created by Meng Li on 07/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import RxDataSources

let attributeImgaes = ["tab_project", "privilege"]

class ProjectViewController: HttperViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .background
        tableView.register(cellType: SelectionTableViewCell.self)
        tableView.register(cellType: RequestTableViewCell.self)
        tableView.register(cellType: DeleteTableViewCell.self)
        tableView.rowHeight = 60
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            self.viewModel.pick(at: indexPath)
        }).disposed(by: disposeBag)
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ProjectSectionModel>(configureCell: { (dataSource, tableView, indexPath, item) in
        switch dataSource[indexPath] {
        case .selectionItem(let selection):
            let cell = tableView.dequeueReusableCell(for: indexPath) as SelectionTableViewCell
            cell.selection = selection
            return cell
        case .requestItem(let request):
            let cell = tableView.dequeueReusableCell(for: indexPath) as RequestTableViewCell
            cell.request = request
            return cell
        case .deleteItem:
            return tableView.dequeueReusableCell(for: indexPath) as DeleteTableViewCell
        }
    }, titleForHeaderInSection: { (dataSource, index) in
        return " "
    })

    
    private let viewModel: ProjectViewModel
    
    init(viewModel: ProjectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dao = DaoManager.shared
    let sync = SyncManager.shared
    
    var project: Project!
    var selectedRequest: Request!
    var requests: [Request]!

    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topPadding)
            $0.left.right.bottom.equalToSuperview()
        }
        
        viewModel.title.bind(to: rx.title).disposed(by: disposeBag)
        viewModel.sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    /** MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 30))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "projectNameSegue", sender: self)
            case 1:
                break
            case 2:
                self.performSegue(withIdentifier: "introductionSegue", sender: self)
            default:
                break
            }
        } else if indexPath.section == 1 {
            selectedRequest = project.requests?[indexPath.row] as! Request?
            self.performSegue(withIdentifier: "projectRequestSegue", sender: self)
        }
    }
    */
    
    // MARK: - Action
    @IBAction func deleteRequestFromProject(_ sender: UIButton) {
        let cell: UITableViewCell = (sender as UIView).superview?.superview as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)!
        let url = (cell.viewWithTag(1) as! UILabel).text!
        let method = (cell.viewWithTag(2) as! UILabel).text!
        let message = R.string.localizable.delete_request_confirm() + url + "(" + method + ")"
        let alertController = UIAlertController(title: R.string.localizable.tip_name(),
                                                message: message,
                                                preferredStyle: .alert)
        let cancel = UIAlertAction(title: R.string.localizable.cancel_name(),
                                   style: .cancel,
                                   handler: nil)
        let confirm = UIAlertAction(title: R.string.localizable.yes_name(),
                                    style: .destructive) { (action) in
            // Remove request from table view.
            self.requests.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            // Remove it from persistent store and server.
            let deletedRequest = self.project.requests?[indexPath.row] as! Request
            self.sync.deleteRequest(deletedRequest, completionHandler: nil)

        }
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteProject(_ sender: UIButton) {
        let alertController = UIAlertController(title: R.string.localizable.delete_project(),
                                                message: R.string.localizable.delete_project_message(),
                                                preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: R.string.localizable.yes_name(),
                                    style: .destructive) { (action) in
            // Remove it from persistent store and server.
            self.sync.deleteProject(self.project, completionHandler: { (revision) in
                self.navigationController?.popViewController(animated: true)
            })
        }
        let cancel = UIAlertAction(title: R.string.localizable.cancel_name(),
                                   style: .cancel,
                                   handler: nil)
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        alertController.popoverPresentationController?.sourceView = sender;
        alertController.popoverPresentationController?.sourceRect = sender.bounds;
        self.present(alertController, animated: true, completion: nil)
    }
    
    /** MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectHistorySegue" {
            // Pop history view controller to this view controller.
            segue.destination.setValue(false, forKey: "push")
        } 
        switch segue.identifier {
        case R.segue.projectTableViewController.projectRequestSegue.identifier:
            let destination = segue.destination as! RequestViewController
            destination.request = selectedRequest
        case R.segue.projectTableViewController.projectNameSegue.identifier:
            let destination = segue.destination as! ProjectNameViewController
            destination.project = project
        case R.segue.projectTableViewController.introductionSegue.identifier:
            let destination = segue.destination as! ProjectIntroductionViewController
            destination.project = project
        default:
            break
        }
    }
     */
    
    // MARK: - Service
    func syncRequests() {
        // Pull new updated requests from server.
        sync.pullUpdatedRequests { (revision) in
            self.requests = self.project.requests?.array as! [Request]
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
        }
    }
    
    // Initialize loading view
    func initLoadingView() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.lightGray
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] in
            // Add your logic here
            self?.syncRequests()
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(hex: DesignColor.nagivation.rawValue))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

}

extension ProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }

}
