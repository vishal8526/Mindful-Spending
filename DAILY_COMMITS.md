# Daily GitHub Graph Workflow

Use this to create one small commit per day.

## Command

Run from project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\daily-commit.ps1
```

Optional custom message:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\daily-commit.ps1 -Message "chore: daily update"
```

## What it does

- Creates/updates a file in `daily-log/YYYY-MM-DD.md`
- Adds one timestamp entry
- Commits only that daily file
- Pushes to your current branch remote

## One-time setup (important for GitHub graph)

Set your git identity in this repo to a GitHub-linked email before daily commits:

```powershell
git config user.name "vishal8526"
git config user.email "vishal63mittal@gmail.com"
```

If your GitHub account uses a different verified email, use that instead.

## Optional: fully automatic daily commit (GitHub Actions)

This repository includes a workflow at `.github/workflows/daily-graph.yml`.

- Runs every day at **04:20 UTC**
- Appends one line to `daily-log/YYYY-MM-DD.md`
- Commits and pushes with your configured Git identity

You can also run it manually from GitHub:

- Open **Actions** tab
- Select **Daily Graph Update**
- Click **Run workflow**
