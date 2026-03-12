# Summary

## Goal
Convert the repository from an Ollama-branded and Ollama-cloud-integrated codebase to a `psyllama`-branded, `psyllama`-namespaced fork.

## Key findings about current `ollama.com` usage
The repository references `ollama.com` for multiple distinct concerns:

- **Downloads / installers**
  - `https://ollama.com/install.sh`, `https://ollama.com/install.ps1`
  - `https://ollama.com/download/...` artifacts (Linux/macOS/Windows)

- **Cloud inference proxying**
  - Server-side cloud proxy defaults to `https://ollama.com:443`
  - Requests may be signed and forwarded upstream for cloud models

- **Hosted REST APIs**
  - `https://ollama.com/api/web_search`
  - `https://ollama.com/api/web_fetch`
  - `https://ollama.com/api/tags`
  - `https://ollama.com/api/chat` (docs/examples)

- **Authentication / API keys / account flows**
  - API keys at `https://ollama.com/settings/keys`
  - Signing flows that special-case `ollama.com` in some client/tool code

- **Model library and registry**
  - UI/docs references to `https://ollama.com/library` and related pages
  - Registry-related code uses `registry.ollama.ai` masks and a manifest spec reference

- **Upgrade UX**
  - UI links to `https://ollama.com/upgrade`

## Decisions you made (authoritative)
- **Command name**: change to `psyllama` (e.g. `psyllama run ...`).
- **Go module path**: change to `github.com/LordPsyan/psyllama`.
- **Environment variables**: introduce `PSYLLAMA_*` and remove any need for `OLLAMA_*`.
- **Cloud**: disable cloud features for now; revisit later.
- **Canonical spelling**: always `psyllama` (not `psyallama`).

## Recommended implementation approach (high level)
- **Phase 1 (mechanical / compile-first):**
  - Update module path and rewrite internal imports.
  - Keep behavior changes minimal until the repo builds cleanly.

## Current status
- **Phase 1 (mechanical / compile-first)**: completed
- **Test status**: `go test ./...` passes
- **Notable adjustments**:
  - Config backup temp dir renamed from `ollama-backups` to `psyllama-backups`.
  - Permission-based tests in `cmd/config` are skipped when running as `root` (since root bypasses chmod-based failure conditions).

- **Phase 2 (product surface):**
  - Rename CLI binary/command to `psyllama`.
  - Update UI/docs strings and links.
  - Migrate env vars to `PSYLLAMA_*`.

- **Phase 3 (external services):**
  - Remove/disable `ollama.com` cloud proxy, web search/fetch tools, and any registry auth assumptions.
  - Later, implement `psyllama.com` equivalents if desired.
