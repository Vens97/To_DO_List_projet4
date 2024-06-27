import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    private var allToDoItems: [ToDoItem] = []

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        let items = repository.loadToDoItems()
        self.allToDoItems = items
        self.toDoItems = items
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        allToDoItems.append(item)
        applyFilter(at: currentFilterIndex)
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = allToDoItems.firstIndex(where: { $0.id == item.id }) {
            allToDoItems[index].isDone.toggle()
            applyFilter(at: currentFilterIndex)
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        allToDoItems.removeAll { $0.id == item.id }
        applyFilter(at: currentFilterIndex)
    }

    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        currentFilterIndex = index
        switch index {
        case 1:
            toDoItems = allToDoItems.filter { $0.isDone }
        case 2:
            toDoItems = allToDoItems.filter { !$0.isDone }
        default:
            toDoItems = allToDoItems
        }
    }

    // Current filter index
    private var currentFilterIndex: Int = 0
}
