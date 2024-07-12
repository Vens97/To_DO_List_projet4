import SwiftUI

/// ViewModel pour gérer la logique de la liste des tâches
final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties
    
    // Repository pour charger et sauvegarder les tâches
    private let repository: ToDoListRepositoryType
    // Liste de toutes les tâches sans filtrage
    private var allToDoItems: [ToDoItem] = []
    
    // MARK: - Init
    
    /// Initialisation du ViewModel avec le repository
    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        // Charger les tâches depuis le repository
        let items = repository.loadToDoItems()
        self.allToDoItems = items
        self.toDoItems = items
    }
    
    // MARK: - Outputs
    
    /// Publisher pour la liste des tâches à afficher
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            // Sauvegarder les tâches à chaque mise à jour
            repository.saveToDoItems(toDoItems)
        }
    }
    
    // MARK: - Inputs
    
    /// Ajouter une nouvelle tâche avec priorité et catégorie
    func add(item: ToDoItem) {
        // Ajouter la tâche à la liste complète des tâches
        allToDoItems.append(item)
        // Appliquer le filtre actuel pour mettre à jour la liste affichée
        applyFilter(at: currentFilterIndex)
    }
    
    /// Basculer l'état de complétion d'une tâche
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        // Trouver l'index de la tâche dans la liste complète
        if let index = allToDoItems.firstIndex(where: { $0.id == item.id }) {
            // Basculer l'état de complétion
            allToDoItems[index].isDone.toggle()
            // Appliquer le filtre actuel pour mettre à jour la liste affichée
            applyFilter(at: currentFilterIndex)
        }
    }
    
    /// Supprimer une tâche de la liste
    func removeTodoItem(_ item: ToDoItem) {
        // Supprimer la tâche de la liste complète
        allToDoItems.removeAll { $0.id == item.id }
        // Appliquer le filtre actuel pour mettre à jour la liste affichée
        applyFilter(at: currentFilterIndex)
    }
    
    /// Appliquer le filtre pour mettre à jour la liste des tâches affichées
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
