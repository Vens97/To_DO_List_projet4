import SwiftUI

// Déclaration de la structure ToDoListView conforme au protocole View
struct ToDoListView: View {
    // Propriété observée pour le ViewModel
    @ObservedObject var viewModel: ToDoListViewModel
    // États pour la gestion des entrées utilisateur et de l'interface
    @State private var newTodoTitle = "" // Stocke le titre du nouveau todo
    @State private var isShowingAlert = false // Contrôle l'affichage de l'alerte
    @State private var isAddingTodo = false // Contrôle l'affichage de la vue d'ajout de todo

    // Nouvel état pour l'index du filtre
    @State private var filterIndex = 0 {
        // Applique le filtre lorsque l'index change
        didSet {
            viewModel.applyFilter(at: filterIndex)
        }
    }

    // Corps de la vue
    var body: some View {
        // Vue de navigation pour fournir une barre de navigation
        NavigationView {
            // Disposition verticale
            VStack {
                // Picker pour sélectionner le filtre de tâches
                Picker("Filter", selection: $filterIndex) {
                    Text("All").tag(0)
                    Text("Done").tag(1)
                    Text("No Done").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Liste des tâches
                List {
                    // Itération sur les éléments de la liste de tâches
                    ForEach(viewModel.toDoItems) { item in
                        HStack {
                            // Bouton pour marquer la tâche comme terminée ou non
                            Button(action: {
                                viewModel.toggleTodoItemCompletion(item)
                            }) {
                                // Icône pour indiquer l'état de la tâche
                                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(item.isDone ? .green : .primary)
                            }
                            // Texte de la tâche avec style conditionnel
                            Text(item.title)
                                .font(item.isDone ? .subheadline : .body)
                                .strikethrough(item.isDone)
                                .foregroundColor(item.isDone ? .gray : .primary)
                        }
                    }
                    // Gestion de la suppression des tâches
                    .onDelete { indices in
                        indices.forEach { index in
                            let item = viewModel.toDoItems[index]
                            viewModel.removeTodoItem(item)
                        }
                    }
                }

                // Vue fixe en bas pour ajouter de nouvelles tâches
                if isAddingTodo {
                    HStack {
                        // Champ de texte pour entrer le titre de la nouvelle tâche
                        TextField("Enter Task Title", text: $newTodoTitle)
                            .padding(.leading)

                        Spacer()
  
                        // Bouton pour ajouter la nouvelle tâche
                        Button(action: {
                            if newTodoTitle.isEmpty {
                                isShowingAlert = true // Affiche l'alerte si le titre est vide
                            } else {
                                viewModel.add(
                                    item: .init(
                                        title: newTodoTitle
                                    )
                                )
                                newTodoTitle = "" // Réinitialise le titre du nouveau todo
                                isAddingTodo = false // Ferme la vue d'ajout après ajout
                            }
                        }) {
                            // Icône pour le bouton d'ajout
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }

                // Bouton pour afficher ou masquer la vue d'ajout
                Button(action: {
                    isAddingTodo.toggle()
                }) {
                    Text(isAddingTodo ? "Close" : "Add Task")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()

            }
            .navigationBarTitle("To-Do List")
            .navigationBarItems(trailing: EditButton()) // Bouton pour passer en mode édition
        }
    }
}

// Prévisualisation de la vue avec des données simulées
struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(
            viewModel: ToDoListViewModel(
                repository: ToDoListRepository()
            )
        )
    }
}
