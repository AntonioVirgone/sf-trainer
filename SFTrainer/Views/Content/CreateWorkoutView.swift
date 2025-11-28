import SwiftUI

struct CreateWorkoutView: View {
    @State private var name = ""
    @State private var plans: [Plan] = []
    @State private var selectedPlanIds: Set<String> = []
    
    @State private var saveSuccess = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Nome Workout") {
                    TextField("Scheda forza 3 giorni", text: $name)
                }
                
                Section("Seleziona i Plan") {
                    if plans.isEmpty {
                        Text("Nessun plan creato")
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(plans, id: \.id) { plan in
                                    PlanCard(
                                        plan: plan,
                                        isSelected: selectedPlanIds.contains(plan.id)
                                    )
                                    .onTapGesture {
                                        toggleSelection(plan.id)
                                    }
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        .frame(height: 260)
                    }
                }
                
                Section {
                    Button("Crea Workout") {
                        saveWorkout()
                    }
                    .disabled(name.isEmpty || selectedPlanIds.isEmpty)
                }
            }
            .background(backgroundGradient)        // 🔥 Funziona
            .navigationTitle("Nuovo Workout")
            .task { loadPlans() }
            .alert("Workout creato!", isPresented: $saveSuccess) {
                Button("OK") {}
            }
        }
    }
    
    // MARK: - LOGICA
    
    private func toggleSelection(_ id: String) {
        if selectedPlanIds.contains(id) {
            selectedPlanIds.remove(id)
        } else {
            selectedPlanIds.insert(id)
        }
    }
    
    private func loadPlans() {
        plans = PlanLocalService.shared.getAll()
    }
    
    private func saveWorkout() {
        WorkoutLocalService.shared.create(
            name: name,
            planIds: Array(selectedPlanIds)
        )
        
        saveSuccess = true
        reset()
    }
    
    private func reset() {
        name = ""
        selectedPlanIds = []
    }
}

struct PlanCard: View {
    let plan: Plan
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(plan.name)
                    .font(.headline)
                Text("Giorni: \(plan.name)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
    }
}
