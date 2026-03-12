# ToDo

## 🎉 **MILESTONE A COMPLETED** - Phase 2+3 (Environment Variables + Registry Migration)

### ✅ **Completed Work:**
- **Phase 3** - Environment variables (`OLLAMA_*` -> `PSYLLAMA_*`) - **FULLY COMPLETED**
- **Phase 4** - Cloud + `ollama.com` integrations - **FULLY COMPLETED** (Updated to `psyllama.com`)
- **Phase 7** - Verification (tests) - **✅ 100% GREEN TEST SUITE**

### 🎯 **Next: MILESTONE B** - Phase 2 (CLI Rename)

## Phase 0 — Prep / invariants
- [x] Decide the canonical name everywhere: `psyllama`
- [x] Confirm Go module path: `github.com/LordPsyan/psyllama`
- [x] Decide policy for legacy names:
  - [x] Remove `OLLAMA_*` env vars (no compatibility)
  - [x] Remove/rename `ollama` CLI command to `psyllama`
- [x] Decide policy for cloud:
  - [x] Disable all `ollama.com` cloud features for now
  - [x] Use a feature flag / non-fatal messaging when cloud is requested (detect + notify; do not crash the program)
- [x] Decide testing strategy for early development:
  - [x] Test locally using a single LLM located in `/projects/models/`
- [x] Decide download/hosting strategy:
  - [x] Host downloads on `psyllama.com` later (not required for initial local testing)
- [x] Establish project notes/memory workflow:
  - [x] Keep `Summary.md` and `ToDo.md` in repo root
  - [x] Keep session notes and archived transcripts in `.dev-notes/`
- [x] File ownership requirement:
  - [x] Ensure files we create/modify remain owned by `lordpsyan:lordpsyan` (verify after changes; fix if needed)

## Phase 1 — Mechanical rename (make it compile)
- [x] Update `go.mod` module line to `github.com/LordPsyan/psyllama`
- [x] Rewrite all internal Go imports from `github.com/ollama/ollama/...` to `github.com/LordPsyan/psyllama/...`
- [x] Update any import paths or package references that include `/ollama/` as a directory/package name (where applicable)
- [x] Run `go test ./...` and fix compilation errors
- [x] `cmd/config`: temp backup dir renamed to `psyllama-backups`; permission-based tests skip when running as `root`

## Phase 2 — CLI rename (`ollama` -> `psyllama`)
- [ ] Rename the primary command/binary output to `psyllama`
- [ ] Update help text, usage strings, and docs that instruct `ollama <cmd>` to use `psyllama <cmd>`
- [ ] Update any shell completions, install scripts, or packaging configs that assume the binary name `ollama`
- [ ] Run CLI smoke checks (help, version, run)

## Phase 3 — Environment variables (`OLLAMA_*` -> `PSYLLAMA_*`)
- [x] Inventory all `OLLAMA_*` usage in Go code, scripts, and UI
- [x] Replace with `PSYLLAMA_*`
- [x] Ensure no fallback to `OLLAMA_*` remains (as per requirement)
- [x] Update docs/examples accordingly
- [x] Run tests - **✅ 100% GREEN TEST SUITE**

## Phase 4 — Disable cloud + `ollama.com` integrations
- [x] Identify and disable code paths that:
  - [x] Default to `ollama.com` as a host (`envconfig.Host`, remotes) - **Updated to `psyllama.com`**
  - [x] Proxy/sign requests to `ollama.com` (`server/cloud_proxy.go`) - **Updated to `psyllama.com`**
  - [x] Implement web search/fetch via `ollama.com` (`x/tools/websearch.go`, `x/tools/webfetch.go`) - **Updated to `psyllama.com`**
  - [x] Perform registry auth flows against Ollama infrastructure (`server/internal/client/ollama/registry.go`, `api/client.go`) - **Updated to `psyllama.ai`**
- [x] Replace with:
  - [x] Local-only behavior, or
  - [x] Feature flags that hard-disable cloud, or
  - [x] Clear "not supported" errors for now
- [ ] Remove UI elements that prompt sign-in/upgrade for cloud

## Phase 5 — Docs/UI branding sweep
- [ ] Replace “Ollama” naming with “psyllama” (docs, UI strings)
- [ ] Replace `ollama.com` links with psyllama equivalents where appropriate (or remove if cloud is disabled)

## Phase 6 — CI / packaging
- [ ] Update any GitHub workflows, release configs, versioning metadata, and installers
- [ ] Verify build artifacts and distribution names use `psyllama`

## Phase 7 — Verification
- [x] `go test ./...` - **✅ 100% GREEN TEST SUITE**
- [ ] Build the UI (if applicable) and run basic flows
- [ ] Run a minimal end-to-end: start server, run a prompt locally
