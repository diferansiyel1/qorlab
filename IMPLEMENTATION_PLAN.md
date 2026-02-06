# QorLab — MVP → Production Implementation Plan (Offline‑First, Premium, No‑Account, Encrypted `.ql`)

This plan is the execution contract for moving QorLab from MVP to production while respecting `PROJECT_CONSTITUTION.md`:

- **Offline‑first** at all times.
- **Package isolation** (no feature↔feature imports; communicate through core ports).
- **Scientific precision** (use `decimal`, not `double`, for chemistry/units/dose/molarity).
- **Additive database migrations only**.
- **Riverpod**: new core state should use `@riverpod` (generator) rather than ad‑hoc `setState` or manual providers.

---

## 0) Product decisions (locked baseline)

- **No user accounts, no cloud sync.** The app is fully functional offline.
- **Premium monetization** via store entitlements (Apple/Google purchase + restore). No PII is required.
- **Portability + device migration** via an **encrypted QorLab Archive** file: **`.ql`**.
- **Default language: English.** All new strings go through localization so TR/other languages can be added later.

**Tradeoff accepted:** without sync, there is no automatic multi‑device merge. Import semantics are explicit (Replace vs Import‑as‑Copy).

---

## 1) Architecture: “Experiment Session + Typed Events” is the spine

### 1.1 Single logging contract (core port)

Goal: every feature (timers, voice, photo, measurements, calculators) logs into the ELN without feature↔feature coupling.

Create a new core package (name may vary, but keep it in `packages/core/`), e.g.:

- `packages/core/experiment_domain`
  - `ExperimentSession` (active experiment + t=0 baseline)
  - `ExperimentEvent` (typed payloads with versioning)
  - `ExperimentEventLogger` interface (write event)

Existing ports in feature packages (e.g. `ExperimentActionHandler`, `DoseLogger`, `MolarityLogger`, `TimerLogger`) should become thin adapters to the new logger or be replaced gradually without breaking existing flows.

### 1.2 Enforce monorepo boundaries (production hardening)

Current state includes feature UI living in `apps/mobile/lib/features/...`. For production:

- Create/expand feature packages for:
  - Home/Dashboard + Files + Settings (e.g. `packages/features/workbench`)
  - Existing: `experiment_log`, `smart_timer`, `in_vivo`, `in_vitro`, `ui_kit`
- Move UI pages out of `apps/mobile/lib/features/...` into feature packages.
- `apps/mobile` becomes routing + configuration + dependency injection/overrides only.

**Acceptance:** `apps/mobile` contains no feature business logic and minimal UI.

---

## 2) Data model: additive Isar evolution

### 2.1 Make “session time” first‑class

Additive schema updates (no deletions/renames):

- `Experiment` add:
  - `startedAt` (DateTime)
  - `endedAt` (DateTime?)
  - optionally `lastEventAt` (DateTime) for listings
- `LogEntry` add:
  - `kind` (string enum: `voice|photo|timer|measurement|calculation|observation|system`)
  - `tOffsetMs` (int; relative to `Experiment.startedAt`)
  - `payloadVersion` (int)
  - keep `metadata` JSON but enforce a schema per `kind`

### 2.2 Measurements + charting: introduce a series model

Graphing requires queryable numeric time series (not freeform strings).

Choose one and commit early:

**Option A (recommended): new collections**
- `MeasurementSeries` (id, experimentId, label, unit, color, source, createdAt)
- `MeasurementPoint` (id, experimentId, seriesId, tOffsetMs, `valueDecimalString`, note?, createdAt)

**Option B (not recommended): encode points in `LogEntry.metadata`**

**Acceptance:** any experiment can render a measurement series chart with correct units and chronological ordering.

---

## 3) Production core capabilities (must‑have)

### 3.1 Photo capture → ELN

- Camera + gallery import
- Persist media to app storage using content‑hash filenames
- Log an event:
  - `kind=photo`, payload references blob hash/path + optional caption
- Timeline UI:
  - thumbnail + full‑screen viewer

### 3.2 Voice note as a scientific record

Production voice note = audio + transcript + confidence:

- Record audio to file (offline)
- Best‑effort on‑device STT to produce transcript
- Log payload:
  - audio blob hash/path, transcript, confidence, languageCode
- Timeline UI:
  - playback + transcript + “edit transcript”
  - edits should create a revision event (no silent overwrite)

### 3.3 Timer + lap + protocol

Deliver in two steps:

- **Stopwatch/Lap** (reliable): logs lap events with `tOffsetMs`
- **Smart Multi‑Timer** (hard):
  - persist state (Isar)
  - schedule local notifications
  - auto‑log start/finish events
  - protocol steps: sequential + parallel

### 3.4 Calculators “Insert to Notebook”

Every calculator result logs `kind=calculation` with:

- `calculatorId` + `algorithmVersion`
- inputs (Decimal as strings)
- outputs (Decimal as strings)
- units + assumptions

This supports later paper/report defensibility.

---

## 4) Encrypted QorLab Archive (`.ql`) — portability backbone

### 4.1 Canonical archive format (cross‑platform)

Do **not** export raw Isar files. Define a canonical archive:

- Single file: `.ql`
- Encryption envelope header:
  - magic bytes + `archiveVersion`
  - KDF params + salt + nonce
- Encrypted payload: a ZIP‑like bundle

Bundle contents (inside encryption):

- `manifest.json`
  - archiveVersion
  - exportedAt, exportedByAppVersion
  - schema versions
  - locale
  - counts + checksums
- `experiments.jsonl`
- `log_entries.jsonl`
- `measurement_series.jsonl` (if using Option A)
- `measurement_points.jsonl` (if using Option A)
- `blobs/` (photos/audio/attachments), addressed by content hash
- `checksums.txt` (sha256 list)

**Decimal rule:** all scientific numbers are stored as **strings** with explicit units.

### 4.2 Encryption (no account, no server)

- Password‑based encryption:
  - AEAD: AES‑256‑GCM (or XChaCha20‑Poly1305)
  - KDF: prefer Argon2id; if constrained, PBKDF2‑HMAC‑SHA256 with strong parameters

UX rules:

- Export is **encrypted by default**
- Warn: password cannot be recovered
- Confirm password + strength hint

Import rules:

- **Import‑as‑Copy** (safe default): creates new experiments with new IDs; preserve original IDs in metadata
- **Replace device data** (dangerous): explicit confirmation required

### 4.3 Desktop/Web reader (paper writing)

Stage 1 (fastest):

- Flutter desktop app (read‑only) that opens `.ql`, browses experiments/timeline/graphs, exports PDF/CSV.

Stage 2 (optional):

- Web reader via file picker (read‑only), optionally persists to IndexedDB.

---

## 5) Refactors required to meet the Constitution

### 5.1 Riverpod generator standardization

New core controllers must use `@riverpod`:

- active session provider
- event logging controller
- measurement series controllers
- archive export/import controllers

Convert legacy `setState` gradually; do not destabilize product.

### 5.2 Scientific precision cleanup

`packages/core/chemical_reference` currently uses `double`. Production migration:

- adopt Decimal‑backed chemical values (or store strings and parse to Decimal)
- ensure `in_vitro` uses a single chemical model (no duplicates)

**Acceptance:** any chemistry calculation path uses Decimal end‑to‑end.

### 5.3 Package API hygiene

- No importing `src/...` from other packages. Expose via public exports.
- Features never import other features directly; communicate only through core contracts/ports.

---

## 6) Localization policy (English default, multi‑language ready)

- All new UI strings go into:
  - `packages/core/localization/lib/l10n/app_en.arb`
- Avoid hardcoded strings in new/modified production screens (archive export/import, measurements, protocols, timeline).
- Adding TR/other languages later should require **no code changes**, only ARB updates.

---

## 7) Testing & release gates (production discipline)

### 7.1 Unit tests (mandatory)

- Archive:
  - export→import roundtrip
  - wrong password fails
  - checksum mismatch fails
- Event model:
  - `tOffsetMs` correctness
  - payload version compatibility
- Measurements:
  - series query + point ordering

### 7.2 Golden tests (where visuals matter)

- timeline cards
- graph widgets

### 7.3 Migration safety

- “DB opens with new fields” tests
- Never delete existing schemas; additive only

---

## 8) Execution plan (shippable phases)

### Phase 0 — Foundation (Production spine)

- Implement ExperimentSession + typed events + logger port
- Add additive Isar fields
- Update timeline mapping to typed events
- English localization pass for touched UI

### Phase 1 — Capture + Graph

- Photo capture + timeline rendering
- Measurement series + point entry + chart view
- Calculator insert‑to‑notebook standardized payloads

### Phase 2 — Encrypted `.ql` Archive

- Export selected experiments / export all
- Import‑as‑copy + replace flows
- Desktop viewer (read‑only + export)

### Phase 3 — Timers to lab‑grade

- Stopwatch/lap
- Multi‑timer persistence + notifications + auto‑log
- Protocol steps + phase tagging

### Phase 4 — Polish + compliance

- Performance for large timelines, indexing, UX glove targets
- Paper‑friendly export (PDF/CSV), charts embedded
- Premium entitlement UX (restore, offline grace)

---

## 9) Open decisions (must be confirmed before building `.ql`)

1. `.ql` extension is final? (If yes, proceed.)
2. Import default behavior is **Import‑as‑Copy**? (Recommended.)
3. Desktop companion is **read‑only in v1**? (Recommended.)

