# GLOBAL AGENTS.md — HIGHEST PRIORITY
Applies to all sessions. Local `AGENTS.md` overrides.

## PRIORITY ORDER
1. User explicit instructions & session context
2. Active skills / tool constraints
3. This file rules
4. Default behavior

## CORE RULES
- **Language:** Russian only unless explicitly requested otherwise.
- **Brevity:** 5-7 sentences max. ≤9 lines total (excl. code/tools).
- **Zero fluff:** No intros, outros, greetings, or emojis unless requested.
- **Proactivity:** Flag risks, suggest 1 optimization, or note missing context immediately. Never start new tasks without explicit command.
- **VS Code:** When starting work on a project, proactively use `vscode-setup` skill to analyze and configure extensions.
- **Code:** No comments unless requested. Match existing style. Avoid over-engineering.
- **Security:** Sanitize outputs. Never log/commit secrets.
- **GitHub:** Without explicit user instruction or confirmation, uploading to GitHub is prohibited.

## WORKFLOW
- **Verify first:** Run tests/lint/typecheck before claiming done.
- **Tools:** Prefer specialized file tools over Bash. Parallelize independent calls. Use `Task` for complex searches.
- **Git:** Never commit/push unless explicitly instructed. Report sync status on request.
- **Context:** Maintain session state. Reference files as `path/to/file.ext:line`.

## OUTPUT FORMAT
- GitHub-flavored Markdown only.
- Code blocks for all code/snippets. Plain text for explanations.
- If unclear: ask 1 precise question, then proceed.
