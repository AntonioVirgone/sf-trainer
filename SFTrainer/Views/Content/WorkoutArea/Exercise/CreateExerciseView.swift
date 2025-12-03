import SwiftUI

struct CreateExerciseView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var imageName = ""
    @State private var muscleGroup: MuscleGroupType = .petto
    @State private var sets = 0
    @State private var repetitions = 0
    @State private var recovery = 0
    @State private var instructions: [String] = []
    
    @State private var newInstruction = ""
    @State private var saveSuccess = false
    
    var body: some View {
        NavigationStack {
            twoColumnLayout
                .background(backgroundGradient)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.clear, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationTitle("Nuovo Esercizio")
        }
        .alert("Esercizio salvato!", isPresented: $saveSuccess) {
            Button("OK") {}
        }
    }
    
    // MARK: - Two Column Layout 70% / 30%
    private var twoColumnLayout: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                HStack(alignment: .top, spacing: 24) {
                    
                    // LEFT COLUMN (70%)
                    leftColumn
                        .layoutPriority(1)
                        .frame(maxWidth: geo.size.width * 0.7, alignment: .topLeading)
                    
                    // RIGHT COLUMN (30%)
                    rightColumn
                        .frame(maxWidth: geo.size.width * 0.3, alignment: .topLeading)
                        .padding(.trailing, 32)
                }
                .padding(.horizontal, 24)
                
                saveButton
            }
        }
    }
    
    // MARK: - LEFT COLUMN
    private var leftColumn: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Info esercizio")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                TextField(
                    "",
                    text: $name,
                    prompt: Text("Nome").foregroundColor(.white.opacity(0.5))
                )
                .whiteTextField()
                
                TextField("",
                          text: $description,
                          prompt: Text("Descrizione").foregroundColor(.white.opacity(0.5))
                )
                .whiteTextField()
                
                TextField("",
                          text: $imageName,
                          prompt: Text("Nome immagine (SF Symbol)").foregroundColor(.white.opacity(0.5))
                )
                .whiteTextField()
                
                Text("Gruppo Muscolare")
                    .foregroundColor(.white.opacity(0.7))
                
                MuscleGroupSelector(selected: $muscleGroup)
                    .padding(.vertical)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Parametri base")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                stepper(title: "Set: \(sets)", value: $sets, min: 0, max: 10)
                stepper(title: "Ripetizioni: \(repetitions)", value: $repetitions, min: 0, max: 50)
                stepper(title: "Recupero (sec): \(recovery)", value: $recovery, min: 0, max: 300, step: 30)
            }
        }
    }
    
    func stepper(title: String, value: Binding<Int>, min: Int, max: Int) -> some View {
        stepper(title: title, value: value, min: min, max: max, step: nil)
    }
    
    func stepper(title: String, value: Binding<Int>, min: Int, max: Int, step: Int?) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            if let step = step {
                Stepper("", value: value, in: min...max, step: step)
            } else {
                Stepper("", value: value, in: min...max)
            }

        }
    }
    
    // MARK: - RIGHT COLUMN
    private var rightColumn: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Istruzioni")
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
            
            HStack {
                TextField(
                    "",
                    text: $newInstruction,
                    prompt: Text("Nuova istruzione")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.5))
                )
                .whiteTextField()
                
                Button("Aggiungi") {
                    guard !newInstruction.isEmpty else { return }
                    
                    // Calcolo del numero progressivo
                    let nextNumber = instructions.count + 1
                    
                    // Aggiungo la stringa numerata
                    instructions.append("\(nextNumber). \(newInstruction)")
                    
                    // Reset
                    newInstruction = ""
                }
                .buttonStyle(.borderedProminent)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(instructions, id: \.self) { instr in
                        HStack {
                            Text(instr)
                                .foregroundColor(.white)
                            Spacer()
                            Button {
                                removeInstruction(instr)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.1))
                        )
                    }
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - SAVE BUTTON
    private var saveButton: some View {
        Button(action: { Task { await saveExercise() } }) {
            Text("Salva Esercizio")
                .font(.headline)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(name.isEmpty ? Color.gray : Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 4)
        }
        .disabled(name.isEmpty)
        .padding()
    }
    
    // MARK: - Helpers
    private func removeInstruction(_ instr: String) {
        instructions.removeAll { $0 == instr }
    }
    
    private func saveExercise() async {
        let exercise = Exercise(
            name: name,
            description: description,
            imageName: imageName,
            muscleGroup: muscleGroup,
            sets: sets,
            repetitions: repetitions,
            recovery: recovery,
            instructions: instructions
        )
        
        ExerciseLocalService.shared.create(exercise)
        saveSuccess = true
        resetForm()
    }
    
    private func resetForm() {
        name = ""
        description = ""
        imageName = ""
        muscleGroup = .gambe
        sets = 0
        repetitions = 0
        recovery = 0
        instructions = []
    }
}

// MARK: - TextField Style Helper
extension View {
    func whiteTextField() -> some View {
        self
            .padding(10)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.white)
    }
}

struct MuscleGroupSelector: View {
    @Binding var selected: MuscleGroupType
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(MuscleGroupType.allCases) { group in
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(color(for: group))
                            .frame(width: 70 * 0.8, height: 70 * 0.8)
                            .overlay(
                                Circle()
                                    .stroke(selected == group ? Color.white : .clear, lineWidth: 4)
                            )
                            .shadow(radius: 4)
                        
                        Image(systemName: icon(for: group))
                            .font(.system(size: 28 * 0.8))
                            .foregroundColor(.white)
                    }
                    
                    Text(group.rawValue)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                .onTapGesture {
                    selected = group
                }
            }
        }
    }
    
    // MARK: - Icone per gruppo muscolare
    private func icon(for group: MuscleGroupType) -> String {
        switch group {
        case .petto: return "figure.strengthtraining.traditional"
        case .schiena: return "figure.strengthtraining.functional"
        case .spalle: return "bolt"
        case .braccia: return "hand.wave"
        case .gambe: return "figure.run"
        case .core: return "circle.grid.cross"
        }
    }
    
    // MARK: - Colori
    private func color(for group: MuscleGroupType) -> Color {
        switch group {
        case .petto: return .red
        case .schiena: return .blue
        case .spalle: return .orange
        case .braccia: return .pink
        case .gambe: return .green
        case .core: return .purple
        }
    }
}

