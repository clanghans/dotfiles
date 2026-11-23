## Upstream Contributions (eclipse-score / ETAS)

- Contributions to Eclipse S-CORE (`eclipse-score/*`) are made through ETAS forks under `etas-contrib/`.
- Forks are named with a `score_` prefix: `eclipse-score/<repo>` is forked as `etas-contrib/score_<repo>`. Example: `eclipse-score/cicd_workflows` → `etas-contrib/score_cicd_workflows`.
- The upstream `eclipse-score` PR is the one that counts. Do not open a parallel PR on the fork once the upstream PR exists; close any fork PR that duplicates an upstream change and link the upstream PR.
- When referencing a PR or fork in logbooks, reviews, or commit messages, use the full `owner/repo#N` form.

## Workspace Layout (`~/ws`)

- Work lives under `~/ws/<group>/<repo>/<branch>/`, e.g. `~/ws/eclipse-score/itf/main/`.
- The main checkout is `<repo>/main/`. Each additional branch is a git worktree next to it: `<repo>/<branch>/`.
- Create worktrees from the main checkout with `git worktree add ../<branch> -b <branch>`. Branch names with `/` create nested directories, e.g. `feature/x` → `<repo>/feature/x/`.
- Do not create worktrees or clones elsewhere under `~/ws`.
- Exception: `~/ws/github/dotfiles` stays a flat checkout (no `main/` subdirectory). It is private and linked from many places, so do not move it.
