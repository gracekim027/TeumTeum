//
//  TaskViewModel.swift
//  TeumTeum
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class AddTaskViewModel: ViewModel, ObservableObject {
    
    @Published var showConfirmation = false
    @Published var taskDescription = ""
    @Published var uploadedFiles: [UploadedFile] = []
    
    // Properties for task submission
    @Published var isLoading = false
    @Published var error: Error?
    @Published var createdTaskId: String?
    
    override init(container: DIContainer) {
        super.init(container: container)
        Task {
            await loadSampleFiles()
        }
    }
    
    func loadSampleFiles() {
        if let pdfURL = Bundle.main.url(forResource: "pdf_sample", withExtension: "pdf") {
            let file = UploadedFile(
                id: UUID().uuidString,  // Using string ID instead of UUID
                name: "pdf_sample.pdf",
                type: .pdf,
                url: pdfURL
            )
            uploadedFiles.append(file)
        } else {
            print("Failed to load PDF file: pdf_sample.pdf not found in bundle")
        }
        
        if let mp3URL = Bundle.main.url(forResource: "hashing_audio", withExtension: "mp3") {
            let file = UploadedFile(
                id: UUID().uuidString,  // Using string ID instead of UUID
                name: "hashing_audio.mp3",
                type: .mp3,
                url: mp3URL
            )
            uploadedFiles.append(file)
        } else {
            print("Failed to load MP3 file")
        }
    }

    func addFile(_ url: URL) {
        let fileType: FileType = url.pathExtension == "pdf" ? .pdf : .mp3
        let file = UploadedFile(
            id: UUID().uuidString,  // Using string ID instead of UUID
            name: url.lastPathComponent,
            type: fileType,
            url: url
        )
        uploadedFiles.append(file)
    }
    
    func removeFile(_ file: UploadedFile) {
        uploadedFiles.removeAll { $0.id == file.id }
    }
    
    @MainActor
    func submitTask(with time: Int) async {
        /// for debug
//        container.taskService.appendQueuedFileList(uploadedFiles)
//        self.showConfirmation = true
//        return
        guard let fileInfo = uploadedFiles.first else { return }
        container.taskService.appendQueuedFileList(uploadedFiles)
        isLoading = true
        
        do {
            let taskId = try await container.taskService.createTask(
                description: taskDescription,
                unitTime: time,
                fileInfo: fileInfo
            )
            self.createdTaskId = taskId
            self.showConfirmation = true
            self.isLoading = false
        } catch {
            self.error = error
            self.isLoading = false
        }
    }
}
