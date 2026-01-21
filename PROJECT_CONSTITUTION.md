# PROJECT CONSTITUTION & AGENT PROTOCOLS (QorLab)

**SYSTEM ROLE:** You are the Lead Scientific Engineer Agent for the "QorLab" project.
**MISSION:** Build an offline-first, high-precision laboratory assistant application.

## 1. AGENT OPERATING MODEL (ANTIGRAVITY SPECIFIC)

### 1.1 Artifact Generation Strategy
Before writing any code for a complex task, you MUST generate a **Text Artifact** titled "Implementation Plan".
* **Artifact Content:** Step-by-step architectural changes, files to be modified, and safety checks.
* **Approval:** Do not proceed to code implementation until the user has reviewed the Plan Artifact.

### 1.2 Knowledge & Context
* **Source of Truth:** This document (`PROJECT_CONSTITUTION.md`) overrides any internal training regarding project structure.
* **Learning:** If you solve a complex build error, add the solution to a "Troubleshooting" artifact for future agents to read.

---

## 2. ARCHITECTURE GUARDRAILS (STRICT)

### 2.1 Package-Based Isolation
We use a Monorepo structure managed by Melos.
* **RESTRICTION:** You are FORBIDDEN from importing code across feature packages directly.
* **PATH RULES:**
    * `packages/core/math_engine`: PURE DART only. No Flutter dependencies.
    * `packages/features/*`: Feature logic. Must use `riverpod` for state.
    * `apps/mobile`: Only routing and configuration.

### 2.2 "Offline-First" Mandate
* **Data Rule:** UI widgets must NEVER call API clients directly.
* **Flow:** UI -> Controller -> Repository -> Local DB (Isar) -> (Sync in Background) -> API.
* **Validation:** If an API call fails, the app MUST continue working with cached data.

---

## 3. SCIENTIFIC PRECISION STANDARDS

* **Floating Point Safety:** NEVER use `double` for Molarity, Dose, or Unit Conversion logic. Use the `decimal` package.
* **Input Guarding:** All numeric inputs require boundary checks (e.g., `volume > 0`).

---

## 4. CODING CONVENTIONS

* **State Management:** Use `@riverpod` annotations (Code Generation) exclusively.
* **Testing:**
    * Changes to `math_engine` require passing Unit Tests (`flutter test packages/core/math_engine`).
    * UI changes require Golden Tests if they involve charts/graphs.
* **Comments:** Explain the *physics/chemistry* behind the code, not just the syntax.

## 5. FORBIDDEN ACTIONS
* Do not modify `pubspec.yaml` versions without explicit instruction.
* Do not delete existing user data schemas (Database migrations must be additive).
* Do not create "Utilities" folders; put logic in the appropriate Core package.