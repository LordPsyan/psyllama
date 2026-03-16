# Summary

## Goal
Convert the repository from an Psyllama-branded and Psyllama-cloud-integrated codebase to a `psyllama`-branded, `psyllama`-namespaced fork.

## Key findings about current `psyllama.com` usage
The repository references `psyllama.com` for multiple distinct concerns:

- **Downloads / installers**
  - `https://psyllama.com/install.sh`, `https://psyllama.com/install.ps1`
  - `https://psyllama.com/download/...` artifacts (Linux/macOS/Windows)

- **Cloud inference proxying**
  - Server-side cloud proxy defaults to `https://psyllama.com:443`
  - Requests may be signed and forwarded upstream for cloud models

- **Hosted REST APIs**
  - `https://psyllama.com/api/web_search`
  - `https://psyllama.com/api/web_fetch`
  - `https://psyllama.com/api/tags`
  - `https://psyllama.com/api/chat` (docs/examples)

- **Authentication / API keys / account flows**
  - API keys at `https://psyllama.com/settings/keys`
  - Signing flows that special-case `psyllama.com` in some client/tool code

- **Model library and registry**
  - UI/docs references to `https://psyllama.com/library` and related pages
  - Registry-related code uses `registry.psyllama.ai` masks and a manifest spec reference

- **Upgrade UX**
  - UI links to `https://psyllama.com/upgrade`

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
  - Config backup temp dir renamed from `psyllama-backups` to `psyllama-backups`.
  - Permission-based tests in `cmd/config` are skipped when running as `root` (since root bypasses chmod-based failure conditions).

- **Housekeeping**:
  - Ignore local IDE/project state directories: `.windsurf/`, `Service Worker/`.

- **Release**:
  - Current working version: `v0.0.2`.
  - Release pipeline is configured to allow an unsigned/no-notarization alpha release without requiring GitHub Actions signing/notarization secrets.

- **Phase 2 (product surface):**
  - Rename CLI binary/command to `psyllama`.
  - Update UI/docs strings and links.
  - Migrate env vars to `PSYLLAMA_*`.

- **Phase 3 (external services):**
  - Remove/disable `psyllama.com` cloud proxy, web search/fetch tools, and any registry auth assumptions.
  - Later, implement `psyllama.com` equivalents if desired.
