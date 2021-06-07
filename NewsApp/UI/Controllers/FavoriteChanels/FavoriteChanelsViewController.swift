import Shakuro_iOS_Toolbox
import UIKit

class FavoriteChanelsViewController: BaseViewController {

    @IBOutlet private var tableView: UITableView!

    private var interactor: FavoriteChanelsControllerInteractor?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

}

extension FavoriteChanelsViewController: FavoriteChanelsControllerInteractorOutput {

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

 extension FavoriteChanelsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor?.favoriteChanelsObserver.numberOfItemsInSection(section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell.identifier, for: indexPath)
        let chanel = interactor?.favoriteChanelsObserver.itemAtIndexPath(indexPath)
        cell.textLabel?.text = chanel?.name
        cell.accessoryType = chanel?.isFavorite ?? false ? .checkmark : .none

        return cell
    }

}

extension FavoriteChanelsViewController: BaseViewControllerProtocol {

    typealias OptionsType = Void

    static func instantiate(_ appRouter: AppRouter, options: Void) -> UIViewController {
        let viewController = unwrap({ R.storyboard.main.favoriteChanelsViewController() })
        viewController.appRouter = appRouter
        viewController.interactor = FavoriteChanelsControllerInteractor(taskManager: appRouter.taskManager,
                                                                        dataManager: appRouter.dataManager,
                                                                        output: viewController)
        return viewController
    }

}

private extension FavoriteChanelsViewController {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

}
