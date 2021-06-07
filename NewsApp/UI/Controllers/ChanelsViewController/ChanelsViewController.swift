import Shakuro_iOS_Toolbox
import UIKit

class ChanelsViewController: BaseViewController {

    @IBOutlet private var tableView: UITableView!

    private var interactor: ChanelsViewControllerInteractor?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        interactor?.fetchChanels()
    }

    @IBAction private func favoriteChanelsButtonPressed(_ sender: Any) {
        appRouter?.presentController(type: FavoriteChanelsViewController.self,
                                     options: (),
                                     fromViewController: self,
                                     style: .push(asRoot: false),
                                     animated: true)
    }

}

// MARK: - ChanelsViewControllerProtocol

extension ChanelsViewController: ChanelsViewControllerProtocol {

    func applyChanges(changes: [FetchedResultsControllerChangeType]) {
        if view.window == nil {
            tableView.reloadData()
        } else {
            tableView.beginUpdates()
            changes.forEach { (change) in
                switch change {
                case .insert(indexPath: let indexPath):
                    tableView.insertRows(at: [indexPath], with: .fade)
                case .delete(indexPath: let indexPath):
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .move(indexPath: let indexPath, newIndexPath: let newIndexPath):
                    tableView.moveRow(at: indexPath, to: newIndexPath)
                case .update(indexPath: let indexPath):
                    tableView.reloadRows(at: [indexPath], with: .fade)
                case .insertSection(index: let index):
                    tableView.insertSections(IndexSet(integer: index), with: .fade)
                case .deleteSection(index: let index):
                    tableView.deleteSections(IndexSet(integer: index), with: .fade)
                }
            }
            tableView.endUpdates()
        }
    }

    func failure(error: Error) {

    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChanelsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.chanelsObserver.numberOfItemsInSection(section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
                indexPath: indexPath,
                reuseIdentifier: R.nib.chanelsTableViewCell.identifier) as? ChanelsTableViewCell else {
            return UITableViewCell()
        }
        let chanel = interactor?.chanelsObserver.itemAtIndexPath(indexPath)
        cell.textLabel?.text = chanel?.name
        cell.accessoryType = chanel?.isFavorite ?? false ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let channelIdentifier = interactor?.chanelsObserver.itemAtIndexPath(indexPath).identifier else {
            return
        }
        interactor?.addChanelToFavoriteList(identifier: channelIdentifier)
    }

}

// MARK: - BaseViewControllerProtocol

extension ChanelsViewController: BaseViewControllerProtocol {

    typealias OptionsType = Void

    static func instantiate(_ appRouter: AppRouter, options: Void) -> UIViewController {
        let viewController = unwrap({ R.storyboard.main.channelsViewController() })
        viewController.appRouter = appRouter
        viewController.interactor = ChanelsViewControllerInteractor(taskManager: appRouter.taskManager,
                                                                    dataManager: appRouter.dataManager,
                                                                    output: viewController)
        return viewController
    }

}

// MARK: - Private

private extension ChanelsViewController {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(resource: R.nib.chanelsTableViewCell), forCellReuseIdentifier: R.nib.chanelsTableViewCell.identifier)
    }

}
