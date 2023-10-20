import UIKit

// Parte 1: Definindo Protocolos
protocol Task {
    func execute(completion: @escaping () -> Void)
}

protocol TaskDelegate {
    func taskCompleted(task: Task)
}

// Parte 2: Definindo Enums e Structs
enum TaskPriority: Int {
    case low = 0, medium = 1, high = 2
    
    func isHigherPriority(than other: TaskPriority) -> Bool {
            return self.rawValue > other.rawValue
        }
}

struct TaskItem: Task {
    let title: String
    let description: String
    let dueDate: Date
    let priority: TaskPriority

    func execute(completion: @escaping () -> Void) {
        print("Executando a tarefa: \(title)")
        completion()
    }
}

// Parte 3: Implementando Funcionalidades
struct TaskManager {
    var taskList = [TaskItem]()
    var delegate: TaskDelegate?

    mutating func addTask(task: TaskItem) {
        taskList.append(task)
    }

    func executeTasksConcurrently() {
        let group = DispatchGroup()

        for task in taskList {
            group.enter()
            task.execute {
                self.delegate?.taskCompleted(task: task)
                group.leave()
            }
        }

        group.wait()
        print("Todas as tarefas foram concluídas.")
    }

    mutating func sortTasksByPriority() {
        taskList.sort { $0.priority.isHigherPriority(than: $1.priority) }
    }
}

// Parte 4: Testando o Sistema
struct TaskManagerDelegate: TaskDelegate {
    func taskCompleted(task: Task) {
        print("Tarefa concluída: \(task)")
    }
}

var taskManager = TaskManager()
taskManager.delegate = TaskManagerDelegate()

let task1 = TaskItem(title: "Tarefa 1", description: "Descrição da Tarefa 1", dueDate: Date(), priority: .medium)
let task2 = TaskItem(title: "Tarefa 2", description: "Descrição da Tarefa 2", dueDate: Date(), priority: .low)
let task3 = TaskItem(title: "Tarefa 3", description: "Descrição da Tarefa 3", dueDate: Date(), priority: .high)

taskManager.addTask(task: task1)
taskManager.addTask(task: task2)
taskManager.addTask(task: task3)

taskManager.sortTasksByPriority()
taskManager.executeTasksConcurrently()
