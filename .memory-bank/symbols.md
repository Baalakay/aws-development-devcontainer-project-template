# 🔣 Symbol Reference Guide
*v1.0 | Created: 2024-12-19 | Updated: 2024-12-19*

## 📁 File Symbols
- 📂 = /.memory-bank/
- 📦 = /.memory-bank/backups/

## 🔄 RIPER Modes
- Ω₁ = 🔍 RESEARCH ⟶ Read-only analysis and investigation
- Ω₂ = 💡 INNOVATE ⟶ Conceptual exploration and design
- Ω₃ = 📝 PLAN ⟶ Planning and specification development
- Ω₄ = ⚙️ EXECUTE ⟶ Code implementation and modification
- Ω₅ = 🔎 REVIEW ⟶ Code review and validation

## 🛡️ Protection Levels
- Ψ₁ = PROTECTED - DO NOT MODIFY
- Ψ₂ = GUARDED - ASK BEFORE MODIFYING
- Ψ₃ = INFO - CONTEXT NOTE
- Ψ₄ = DEBUG - DEBUGGING CODE
- Ψ₅ = TEST - TESTING CODE
- Ψ₆ = CRITICAL - BUSINESS LOGIC

## 📊 Project Phases
- Π₁ = 🌱 UNINITIATED ⟶ Framework not yet started
- Π₂ = 🚧 INITIALIZING ⟶ START phase active, setup ongoing
- Π₃ = 🏗️ DEVELOPMENT ⟶ Main development phase, RIPER active
- Π₄ = 🔧 MAINTENANCE ⟶ Long-term support, RIPER active

## 📎 Context References
- Γ₁ = 📄 @Files
- Γ₂ = 📁 @Folders
- Γ₃ = 💻 @Code
- Γ₄ = 📚 @Docs
- Γ₅ = 📏 @Cursor Rules
- Γ₆ = 🔄 @Git
- Γ₇ = 📝 @Notepads
- Γ₈ = 📌 #Files

## 🔐 Permission System
- ℙ = {C: create, R: read, U: update, D: delete}
- 𝕊 = Operation categories (observe, virtual, real)

## 🧰 Memory System
- σ₁ = Project Brief (requirements, scope, criteria)
- σ₂ = System Patterns (architecture, components, decisions)
- σ₃ = Technical Context (stack, environment, dependencies)
- σ₄ = Active Context (focus, changes, next steps)
- σ₅ = Progress Tracker (status, milestones, issues)
- σ₆ = Protection Registry (protected regions, history, approvals)

## 🔄 Mode-Context Mapping
- Ω₁ (RESEARCH): [Γ₄, Γ₂, Γ₆] - docs, folders, git
- Ω₂ (INNOVATE): [Γ₃, Γ₄, Γ₇] - code, docs, notepads
- Ω₃ (PLAN): [Γ₁, Γ₂, Γ₅] - files, folders, rules
- Ω₄ (EXECUTE): [Γ₃, Γ₁, Γ₈] - code, files, pinned
- Ω₅ (REVIEW): [Γ₃, Γ₁, Γ₆] - code, files, git

## 🛠️ Quick Commands
- `/start` = Initialize CursorRIPER framework
- `/research` = Enter research mode (Ω₁)
- `/innovate` = Enter innovate mode (Ω₂)
- `/plan` = Enter plan mode (Ω₃)
- `/execute` = Enter execute mode (Ω₄)
- `/review` = Enter review mode (Ω₅)

## 🔍 Protection Commands
- `/protect-scan` = Scan for protection violations
- `/protect-status` = Show protection status
- `/protect-add` = Add protection to selection
- `/protect-remove` = Remove protection with confirmation
- `/protect-approve` = Approve guarded modification

## 📎 Context Commands
- `!af(file)` = Add file reference to context
- `!ac(code)` = Add code reference to context
- `!adoc(doc)` = Add documentation reference
- `!pf(file)` = Pin file to context
- `!cc` = Clear all context references