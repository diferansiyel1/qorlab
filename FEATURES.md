# QORLAB (ANTIGRAVITY) - PRODUCT FEATURES & SPECIFICATIONS

**Document Version:** 1.0
**Status:** Approved for Development
**Core Philosophy:** Offline-First, Scientific Precision, Lab-Centric UX.

---

## 1. PRODUCT OVERVIEW
QorLab is a hybrid Electronic Laboratory Notebook (ELN) and computational assistant designed for wet-lab researchers. It solves the "gloved-hand" problem via voice interfaces and strictly handles scientific data with high precision.

---

## 2. SYSTEM ARCHITECTURE & CONSTRAINTS

### 2.1 Offline-First Mandate
* **Requirement:** The app must be 100% functional (calculations, timers, logging) without internet.
* **Data Strategy:**
    * **Primary Source:** Local Database (Isar/Drift).
    * **Remote Source:** Firebase/REST APIs (only for syncing backups or fetching *new* chemical data).
    * **Fallback:** If API fails, use local cache silently.

### 2.2 Scientific Precision
* **Math Engine:** All chemical calculations (Molarity, Dose) must use the `decimal` type to avoid floating-point errors.
* **Validation:** Inputs must have strict scientific boundaries (e.g., `pH` 0-14, `Kelvin` >= 0).

---

## 3. CORE MODULES

### 3.1 Voice-First Experiment Log (Launch Feature)
* **Goal:** Allow researchers to log data without removing gloves.
* **Functionality:**
    * **Voice Command:** "Log: 5mg/kg Ketamine administered to Group A."
    * **Entity Extraction:** The system parses `5mg/kg` (Value), `Ketamine` (Substance), `Group A` (Subject) and logs them as structured data.
    * **Tech Stack:** On-device Speech-to-Text (iOS/Android Native APIs). Cloud fallback is optional/premium.
    * **Contextual Photos:** Photos taken in "Experiment Mode" are tagged with timestamp + experiment ID and embedded in the log.

### 3.2 Smart Multi-Timer (Protocol Manager)
* **Goal:** Manage overlapping lab protocols (e.g., Western Blot steps).
* **UI Visualization:**
    * **Parallel Bars:** Vertical list of progress bars.
    * **States:** Active (Animated Color), Waiting (Gray), Completed (Green Tick).
    * **Example:** A "Western Blot" protocol spawns 3 sequential timers. As "Blocking" finishes, "Washing" acts as the next step.
* **Background Service:** Timers must persist even if the app is killed or the phone restarts (Critical for long incubations).

### 3.3 In-Vivo Module (Animal Research)
* **Database:** Pre-loaded physiological data for Mouse (C57BL/6, Balb/c), Rat (Wistar), Rabbit.
* **Safety Calculator:**
    * Auto-calculate Max Administration Volumes (IP, IV, SC, Gavaj) based on body weight.
    * **Alert:** Visual Red Warning if user input exceeds ethical limits.
* **Anesthesia:** Cocktail calculator (Ketamine/Xylazine) with stock solution inputs.
* **Randomization:** Tool to assign subjects to groups randomly to prevent bias.

### 3.4 In-Vitro & Chemistry Module
* **Chemical Inventory (Hybrid):**
    * **Seed Data:** Top 1000 common lab chemicals embedded in the app (Offline access to MW, Density).
    * **API Fetch:** Fetch rare chemicals from PubChem (Requires Internet) -> Cache to Local DB immediately.
* **Calculators:**
    * Molarity, Normality, Dilution ($C_1V_1 = C_2V_2$).
    * Cell Culture: Passage calculator, Hemocytometer counter.

---

## 4. UI/UX SPECIFICATIONS (LAB MODE)

### 4.1 "Lab Mode" Interface
* **Trigger:** A toggle to switch UI for active bench work.
* **Ergonomics:**
    * **One-Handed Zone:** All critical buttons (Start, Stop, Log) located in the bottom 40% of the screen.
    * **Touch Targets:** Minimum 56x56dp for gloved usage.
* **Wake Lock:** Screen never sleeps while a timer or experiment is active.

### 4.2 Data Visualization
* **Real-Time Graphing:** Numeric inputs during an experiment (e.g., Blood Pressure at t=0, t=5, t=10) instantly render a line chart.
* **Export:** Generate PDF/Excel reports combining Logs, Photos, and Graphs.

---

## 5. CLOUD & CONNECTIVITY (FIREBASE)

* **Role:** Enhancement only, not dependency.
* **Features:**
    * **Messaging:** Push notifications for updates or lab alerts.
    * **Remote Config:** Dynamic updates for "Tip of the Day" or "News".
    * **Sync:** Background sync of experiment logs for backup (User optional).

---

## 6. IMPLEMENTATION ROADMAP FOR AGENTS

1.  **Phase 1 (Core):** Setup Melos, Isar DB, and the Math Engine (Test Coverage: 100%).
2.  **Phase 2 (Tools):** Implement Calculators and PubChem Caching.
3.  **Phase 3 (Timer):** Build the Background Service and Parallel Bar UI.
4.  **Phase 4 (Voice):** Integrate Speech-to-Text and Data Parsing logic.
5.  **Phase 5 (Cloud):** Add Firebase as a non-blocking layer.