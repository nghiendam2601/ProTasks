//
//  ViewController.swift
//  Pro Tasks
//
//  Created by DamMinhNghien on 18/7/24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    var didselectIndexPath: IndexPath=[0,0]
    var AllTask: Results<Task>?
    var AllDateWithTask = RealmManager.shared.getDatesWithTasks()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if AllDateWithTask == []{
            title = "No Task"
        }
        setupCollectionView()
        setupCollectionViewLayout()
        setupTableView()
        loadAddButton()
    }
    //MARK: - Add Button
    func loadAddButton(){
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName:"square.and.pencil"), for: .normal)
        addButton.backgroundColor = UIColor(red: 151/255.0, green: 214/255.0, blue: 222/255.0, alpha: 1)
        addButton.tintColor = .black
        addButton.layer.cornerRadius = 25
        addButton.clipsToBounds = true
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    @objc func addButtonTapped(){
        performSegue(withIdentifier: "goToAdd", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAdd" {
            if let navigationController = segue.destination as? UINavigationController,
               let ActionTaskController = navigationController.topViewController as? ActionTaskViewController {
                ActionTaskController.delegate = self
                ActionTaskController.ActionTask = .add
            }
        }
    }
    //MARK: - Setup CollectionView
    func setupCollectionView(){
        collectionView.register(UINib(nibName: "ScheduleTaskCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ScheduleTaskCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        setupCollectionViewLayout()
    }
    //MARK: - CLV Layout
    func setupCollectionViewLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2 // Khoảng cách giữa các item trong cùng một hàng
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90 , height: 128) // Kích thước của mỗi item
        collectionView.collectionViewLayout = layout
    }
    //MARK: - Setup TableView
    func setupTableView(){
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "taskCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 15
    }


}

//MARK: - CollectionViewDataSource
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AllDateWithTask.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //MARK: cell selected
        if didselectIndexPath == indexPath{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleTaskCell", for: indexPath) as! ScheduleTaskCollectionViewCell
            if Date().startOfDay == AllDateWithTask[indexPath.row].startOfDay{
                title = "Pro Tasks Today"
            }else{
                title = "Future Pro Tasks"
            }
            cell.DayLabel.text = AllDateWithTask[indexPath.row].stringToDay
            cell.YearLabel.text = AllDateWithTask[indexPath.row].stringToYear
            cell.WeekLabel.text = AllDateWithTask[indexPath.row].stringToWeek
            AllTask = RealmManager.shared.getDayTasks(date: AllDateWithTask[indexPath.row]).sorted(byKeyPath: "dueDate", ascending: true)
            cell.MainViewCell.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
            cell.MainViewCell.layer.borderWidth = 3
            tableView.reloadData()
            return cell
        }
        //MARK: normal cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleTaskCell", for: indexPath) as! ScheduleTaskCollectionViewCell
        cell.DayLabel.text = AllDateWithTask[indexPath.row].stringToDay
        cell.YearLabel.text = AllDateWithTask[indexPath.row].stringToYear
        cell.WeekLabel.text = AllDateWithTask[indexPath.row].stringToWeek
        cell.MainViewCell.layer.borderColor = .none
        cell.MainViewCell.layer.borderWidth = 0
        return cell
    }
}
//MARK: - CollectionViewDelegte
extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didselectIndexPath = indexPath
        collectionView.reloadData()
    }
}
//MARK: - TableViewDataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllTask?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        cell.dueDateLabel.text = AllTask?[indexPath.row].dueDate.timeString
        cell.idTask = AllTask?[indexPath.row].id
        cell.ButtonTask.setTitle("", for: .normal)
        if let newStatus = AllTask?[indexPath.row].isCompleted {
            if newStatus{
                cell.ButtonTask.setImage(Config.circleFillIcon, for: .normal)
                cell.TitleLabel.attributedText = NSAttributedString(string: AllTask![indexPath.row].title, attributes: Config.attributes)
            }else{
                cell.TitleLabel.attributedText = NSAttributedString(string: AllTask![indexPath.row].title, attributes: Config.attributesNormal)
                cell.ButtonTask.setImage(Config.circleIcon, for: .normal)
            }
        }
        cell.ButtonTask.clipsToBounds = true
        return cell
    }
    
}
//MARK: - TableViewDelegate
extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailTaskViewController", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailTask") as? DetailTaskViewController{
            vc.titleTask = AllTask?[indexPath.row].title
            vc.noteTask = AllTask?[indexPath.row].note
            vc.id = AllTask?[indexPath.row].id
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
//MARK: - Delegete Pattern
//ReloadView when CRUD Task
extension ViewController: ReloadDelegate{
    func reloadView() {
        tableView.reloadData()
        AllDateWithTask = RealmManager.shared.getDatesWithTasks()
        collectionView.reloadData()
        if AllDateWithTask == []{
            title = "No Task"
        }
    }
    
}

