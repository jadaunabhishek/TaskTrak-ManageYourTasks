//
//  TaskView.swift
//  TaskTrak
//
//  Created by Abhishek Jadaun on 22/01/24.
//

import SwiftUI

struct TaskView: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(task.title ?? "Untitled Task")
                .font(.headline)
            
            Text(task.descriptionTask ?? "No description")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                
                if let date = task.dateTask {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                if let time = task.timeTask {
                    
                    Image(systemName: "clock")
                        .font(.caption)
                        .padding(.leading)
                        .foregroundColor(.blue)
                    
                    Text(time, style: .time)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        let task = Task(context: context)
        task.id = UUID()
        task.title = "Sample Task"
        task.isCompleted = false
        task.dateTask = Date()
        task.timeTask = Date()
        task.descriptionTask = "This is a sample task description."
        
        return TaskView(task: task)
            .previewLayout(.fixed(width: 300, height: 150))
            .environment(\.managedObjectContext, context)
    }
}

