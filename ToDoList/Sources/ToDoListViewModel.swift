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
        // Met à jour l'index actuel du filtre
        currentFilterIndex = index
        
        // Utilise une instruction switch pour déterminer quel filtre appliquer
        switch index {
            // Cas où l'index est 1 (filtre "Done" - tâches terminées)
        case 1:
            // Met à jour toDoItems pour n'inclure que les éléments dont isDone est true
            toDoItems = allToDoItems.filter { $0.isDone }
            
            // Cas où l'index est 2 (filtre "Not Done" - tâches non terminées)
        case 2:
            // Met à jour toDoItems pour n'inclure que les éléments dont isDone est false
            toDoItems = allToDoItems.filter { !$0.isDone }
            
            // Cas par défaut (filtre "All" - toutes les tâches)
        default:
            // Réinitialise toDoItems pour inclure tous les éléments de allToDoItems
            toDoItems = allToDoItems
        }
    }
    
    // Index actuel du filtre
    private var currentFilterIndex: Int = 0
}
