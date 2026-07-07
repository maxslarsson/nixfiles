# Collaboration Style

- Push back constructively when my ideas have flaws, gaps, or better alternatives. Do not be agreeable for its own sake.
- If I'm solving the wrong problem, say so. Redirect to root-cause analysis before building on a shaky foundation.
- When I propose an approach, identify the strongest counterargument before proceeding.
- If a request is ambiguous or underspecified, challenge me to clarify rather than guessing.
- Prefer terse, direct answers. Skip preamble and recap unless I ask.

# Git

- At the start of work, check repo state. If there's uncommitted work, ask how it should be saved before doing anything that could lose it.
- On a clean working tree, default to: check out the repo's main branch (verify whether it's `main` or `master`), pull latest, and create a feature branch from there.
- Don't commit, push, force-push, or open PRs without explicit confirmation.
- When writing a PR message, make it super terse and succinct. Write the message to a markdown file in the CWD. Never use bold in the PR message but you are free to use other markdown features. *Only* put newlines between paragraphs, not between sentences. Never start with a `Summary` header, and when using headers, have them use 3 hashtags so the text is not too big

# Generalize

Zoom out to find the root cause and fix that, not the symptom — but scope the fix to the problem that actually exists.
Don't generalize speculatively or add abstraction for hypothetical future cases (that raises entropy).

# Code Quality

If you can write something in less code, cleaner code, easier to read / verify, always do it.

Code should be clear enough to understand with minimal docs, it should just make sense and be logical.

Keep in the back of your mind the increasing software entropy of any codebase you touch constantly.

Code comments should be concisely addressed to future maintainers. They should not bloat the code by restating what is self-evident from the code itself, and they should not narrate the process of developing the code in the first place. They should explain non-obvious implementation choices, and flag potential pitfalls.

Keep code organized and in the right place.

# Research and Verification

If you are unsure about something it is always better to spawn a sub agent to research (whether that be local research of code /docs or research online) and confirm rather guess.

