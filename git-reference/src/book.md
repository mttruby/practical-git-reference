# Git – Practical Reference Guide

A structured overview for working with Git.

> [!NOTE]
> This guide was put together as a quick reference for fellow participants of our university course. It focuses on the Git basics most relevant for collaborating on a shared project. Things like branches, commits, and undoing mistakes. For a complete Git reference, check out the [official Git documentation](https://git-scm.com/doc).

---

## Table of Contents

1. [How Git Works](#1-how-git-works)
2. [Cloning a Repository](#2-cloning-a-repository)
3. [Configuration](#3-configuration)
4. [Saving Credentials](#4-saving-credentials)
5. [The Daily Workflow: add → commit → push](#5-the-daily-workflow-add--commit--push)
6. [Status and History](#6-status-and-history)
7. [Branches and Merging](#7-branches-and-merging)
8. [Minimal Hands-On Example](#8-minimal-hands-on-example)
9. [Undoing Mistakes](#9-undoing-mistakes)

---

## 1. How Git Works

Git is a **distributed version control system**. Every copy of a repository contains the full history. The four core areas to understand:

```
Working Directory  →  Staging Area  →  Repository  →  Remote
   (your changes)      (git add)      (git commit)   (git push)
```

- **Working Directory**: Where you edit files locally.
- **Staging Area**: Where you collect changes that should go into the next commit.
- **Repository**: The permanent, committed history of all snapshots.
- **Remote**: The shared server (GitHub / GitLab) that others push to and pull from.

> [!NOTE]
> **GitHub or GitLab?** Both platforms use the exact same Git commands. GitHub is more common for open-source projects; GitLab offers more built-in CI/CD features and is often self-hosted. For getting started, the difference is practically irrelevant.

---

## 2. Cloning a Repository

Before you start, get a local copy of the repository:

```bash
git clone https://github.com/example/repo.git
cd repo
```

---

## 3. Configuration

After cloning, Git needs to know who you are. This information appears in every commit you create. The following commands apply to the current repository only.

### Check current values

```bash
git config user.name
git config user.email
```

### Set values

```bash
git config user.name "First Last"
git config user.email "name@example.com"
```

> [!TIP]
> **Optional – set globally:** If you always use the same name and email, you can add `--global`. The setting then applies to all repos on your system and is saved in `~/.gitconfig`:
> ```bash
> git config --global user.name "First Last"
> git config --global user.email "name@example.com"
> ```

---

## 4. Saving Credentials

On your first `git push` (or `git pull` for private repos), you will be prompted for a username and password / token. To avoid entering them every time:

```bash
git config credential.helper store
```

After the next login, credentials are saved in plain text in `~/.git-credentials`. On shared systems, use `cache` instead (stores temporarily in RAM only):

```bash
git config credential.helper cache
```

> [!NOTE]
> Avoid `--global` here – different repositories may use different accounts or servers (e.g. GitHub vs. a self-hosted GitLab), and a global credential helper can cause the wrong credentials to be used.

---

## 5. The Daily Workflow: add → commit → push

### Add files to the staging area

```bash
git add path/to/file.txt      # single file
git add path/to/folder/       # entire folder
git add .                     # all changes in the current directory
```

### Create a commit

```bash
git commit -m "type: short description"
```

#### Commit messages: Conventional Commits

It is recommended to follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) convention:

```
<type>(<optional scope>): <description>

feat:     a new feature
fix:      a bug fix
docs:     documentation changes only
refactor: code restructured without new feature or bug fix
chore:    build process, dependencies, tooling etc.
test:     tests added or updated
```

**Examples:**
```
feat: add login page
fix(auth): token is now validated correctly
docs: update readme
```

### Push commits to the remote

```bash
git push                        # push current branch (if tracking is set)
git push origin main            # explicit: push branch "main" to remote "origin"
git push -u origin my-branch    # first push + set tracking
```

---

## 6. Status and History

### Show current status

```bash
git status
```

Shows which files are modified, staged, or untracked.

### Show commit history

```bash
git log                    # full history
git log --oneline          # compact view (one commit per line)
git log --oneline --graph  # with branch visualization
```

### Fetch remote changes (without merging)

```bash
git fetch
```

Downloads new commits from the remote but does **not** change your local working state. Useful for seeing what others have pushed before merging.

```bash
git pull   # fetch + merge in one step
```

---

## 7. Branches and Merging

### When to create a branch?

Whenever you work on a new feature or bug fix that shouldn't land in the main branch (`main` / `master`) right away. This keeps the main branch stable.

### Branch commands

```bash
git branch                     # list all local branches
git branch my-feature          # create a new branch
git checkout my-feature        # switch to a branch
git checkout -b my-feature     # create AND switch (shorthand)
```

Modern alternative to `checkout`:
```bash
git switch my-feature          # switch branch
git switch -c my-feature       # create + switch
```

### Merging a branch

```bash
git checkout main              # switch to the target branch first
git merge my-feature           # merge the feature branch in
```

```
main:    A──B──────────F
              \        /
feature:       C──D──E
```

### Resolving merge conflicts

A conflict occurs when the same line was changed in both branches. Git marks the location:

```
<<<<<<< HEAD
your code on main
=======
your code on feature-branch
>>>>>>> my-feature
```

How to resolve:
1. Open the conflicting file and manually decide what stays
2. Remove the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
3. `git add path/to/file.txt`
4. `git commit`

### Rebase (advanced)

```bash
git rebase main   # replay current branch on top of main (linear history)
```
> [!TIP]
> **General rule:** Use `merge` for shared branches, `rebase` only locally and only if you know what you're doing.

---

## 8. Minimal Hands-On Example

This example walks through the complete process: configure, create a branch, make a change, commit, and push. Feel free to delete the branch afterwards – it won't affect `main` or clutter the history.

### Step 1: Set name and email (if not already configured)

```bash
git config user.name "Mia Example"
git config user.email "mia@example.com"
```

### Step 2: Create a branch and switch to it

```bash
git checkout -b feature/my-first-branch
```

### Step 3: Create or edit a file

```bash
echo "Hello World" > hello.txt
```

### Step 4: Stage the file

```bash
git add hello.txt
```

### Step 5: Create a commit

```bash
git commit -m "docs: add hello.txt"
```

### Step 6: Push the branch

```bash
git push -u origin feature/my-first-branch
# → enter username and token/password if prompted (only once with credential.helper)

# when pushing to this branch again, you do not need to specify the upstream branch, just use:
git push
```

That's the full loop. Once you're done, the branch can be deleted on the remote without touching `main`:

```bash
git push origin --delete feature/my-first-branch  # delete remote branch
git branch -d feature/my-first-branch             # delete local branch
```

---

## 9. Undoing Mistakes

### I changed a file and want to undo the changes

```bash
git restore path/to/file.txt
git restore path/to/folder/    # entire folder
```

> [!CAUTION]
> Discards all local changes to the file – this cannot be undone!

---

### I staged a file and want to unstage it

```bash
git reset path/to/file.txt
```

> Removes the file from the staging area; the changes remain in the working directory.

**Alternative command** (use with caution):
```bash
git restore --staged path/to/file.txt
```

> [!CAUTION]
> If you forget `--staged`, the file changes will be discarded. Prefer `git reset` for safety.

---

### Unstage all staged files at once

```bash
git reset
```

---

### I created a commit and want to undo it

| Command | Effect |
|---|---|
| `git reset HEAD~1` | Go back 1 commit; files are **unstaged** (changes preserved) |
| `git reset --soft HEAD~1` | Go back 1 commit; files remain **staged** |
| `git reset --hard HEAD~1` | Go back 1 commit; changes are **permanently deleted** |

```bash
# Example: undo last commit, keep changes
git reset HEAD~1

# Go back multiple commits (e.g. 3):
git reset HEAD~3
```

> [!WARNING]
> Only use `--hard` when you are 100% certain. Consider using `git stash` before discarding changes.

---

### I want to see what I've changed

| Command | Effect |
|---|---|
| `git diff` | Show unstaged changes (working directory vs. last commit) |
| `git diff --staged` | Show staged changes (what will go into the next commit) |
| `git diff HEAD` | Show **all** changes – staged + unstaged combined |
| `git diff <commit>` | Compare working directory against a specific commit |
| `git diff <branch>` | Compare working directory against another branch |

```bash
# See all unstaged changes
git diff

# See what's already staged
git diff --staged

# Compare with a specific commit hash
git diff a1b2c3d
```

> [!NOTE]
> `git diff` only shows changes that haven't been committed yet. Once committed, use `git log -p` or `git diff <commit1> <commit2>` to compare commits.

---

### I want to check out a single file from another branch

| Command | Effect |
|---|---|
| `git checkout <branch> -- <file>` | Restore a file from another branch into your working directory |
| `git checkout <commit> -- <file>` | Same, but from a specific commit |

```bash
# Get a single file from another branch
git checkout main -- src/config.ts

# Get a file from a specific commit
git checkout a1b2c3d -- src/config.ts
```

> [!WARNING]
> This **immediately overwrites** the file in your working directory without a confirmation prompt. Stage or stash local changes first if you want to keep them.

---

## Other stuff?

The following topics were hinted at in the notes or are valuable for a complete introduction:

- **`.gitignore`** – telling Git which files to ignore (e.g. `node_modules/`, `.env`, build artifacts)
- **`git stash`** – temporarily shelve changes without committing
- **Pull Requests / Merge Requests** – the review process on GitHub/GitLab; central for teams
- **SSH key setup** – a more secure alternative to password/token credentials
- **Tags** – marking releases with `git tag v1.0.0`
- **Fork workflow** – for contributing to third-party projects
