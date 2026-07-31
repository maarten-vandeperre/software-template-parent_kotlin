# Changes in this revision

## Bug fixes
- **`update_parent_template.sh` marker mismatch (critical):** the script scanned for
  `#### custom-x-stop ####` while every Gradle file uses `#### custom-x-end ####`. The awk
  extraction therefore never reset its flag (capturing from `-start` to end-of-file) and the
  injection pass could delete everything after the start marker. Both passes now use `-end`.
- **`build.gradle` custom blocks lost on update:** the final `cp` in the update script
  overwrote the child's `build.gradle` with the pristine parent copy (the old `TODO` in the
  script acknowledged this). Custom blocks are now extracted before the copy and re-injected
  afterwards.
- **macOS-only `sed -i ''`:** `setup-project.sh` and `update_parent_template.sh` used the BSD
  in-place syntax, which fails on Linux (GNU sed interprets `''` as the script file). A portable
  `sedi()` helper (also in the new `template-scripts/lib-common.sh`) now detects GNU vs BSD sed.
- **bash-only scripts run with `sh`:** `update_parent_template.sh` uses bash arrays but the
  README instructed `sh script_update_parent_template.sh` (fails under dash on Debian/Ubuntu).
  Scripts now guard for bash, internal invocations use `bash`, and the README says `bash ...`.
- **CI workflows referenced a non-existent step:** `labels: ${{ steps.meta.outputs.labels }}`
  pointed at a `meta` step that doesn't exist; removed.
- **Version drift:** `gradle.properties` pinned Spring Boot 2.7.8 while
  `settings.gradle` pluginManagement pinned 3.4.0; aligned to 3.4.0.
- **Blog/repo command mismatch:** the blog post says `./gradlew runMonolith`, the repo only had
  `startMonolith`. A `runMonolith` alias task was added so both work.

## Robustness improvements
- `set -euo pipefail` (or `set -eu`) added where safe; `curl -fsS` so a 404 no longer silently
  writes an HTML error page into a script that then gets executed.
- Blind `sleep 60` / `sleep 10` waits replaced with polling (`until [ -f ... ]` with timeout).
- Absolute-path symlinks (`ln -s $(pwd)/...`) replaced with relative symlinks so checkouts can
  be moved and links survive cloning by teammates; `setup-project.sh` is now safe to re-run
  (pre-existing links are removed first).
- `git commit` now falls back to a bootstrap identity when `user.name`/`user.email` are not
  configured (fresh machines, CI runners) via `git_commit_safe`.
- Interactive `read` now reads from `/dev/tty`, so `curl ... | bash` works as well as
  `bash <(curl ...)`.
- Bootstrap script version bumped to 1.1.0.

## Extensions
- **Unit tests** added for `Response` (core domain) and `DefaultInMemoryDatabase`
  (data provider); JUnit 5 wired into all library subprojects with `useJUnitPlatform()`.
- **CI:** workflows now also build on pull requests (image push still restricted to `main`),
  with per-ref concurrency cancellation.
- **`template-scripts/lib-common.sh`:** shared helpers (`sedi`, `require_bash`,
  `git_commit_safe`, `wait_for_path`) for future scripts.
