$env:PATH += ";c:\Program Files\Git\cmd"
$env:Path += ";C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE"
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/pure.omp.json" | Invoke-Expression

$branch = "~\Documents\git\branch"

function Add-Worktree {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName
    )

    # Base worktree location
    $worktreeBase = "$HOME\Documents\git\branch"
    $worktreePath = Join-Path $worktreeBase $BranchName

    Write-Host "📂 Creating worktree for branch '$BranchName' at '$worktreePath'" -ForegroundColor Cyan

    # Run git worktree add
    git worktree add -b $BranchName $worktreePath#

    Write-Host "✅ Worktree created." -ForegroundColor Green

    # Path to Visual Studio (adjust edition if needed: Community / Professional / Enterprise)
    $vsPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"

    # Find a .sln file in the new worktree
    $sln = Get-ChildItem -Path $worktreePath -Filter *.sln -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($sln) {
        Write-Host "🚀 Opening solution '$($sln.Name)' in Visual Studio..." -ForegroundColor Yellow
        & $vsPath $sln.FullName
    }
    else {
        Write-Host "⚠️ No .sln file found in '$worktreePath'" -ForegroundColor Red
    }
}

# --- Daily Notes (Carmack-style) ---
function note {
    $NotesRepo = "C:\Users\Michael.Beaton\Documents\git\main\daily-notes"
    $EditorCmd = "code"   # VS Code
    $today     = Get-Date -Format "yyyy-MM-dd"
    $file      = Join-Path $NotesRepo "$today.md"

    # Make sure repo exists
    if (!(Test-Path $NotesRepo)) {
        Write-Error "Notes repo not found at: $NotesRepo"
        return
    }

    if (!(Test-Path $file)) {
        # Create file with header and first bullet
        "# Notes for $today`n- " | Out-File -FilePath $file -Encoding UTF8
    } else {
        # Append a new bullet line
        Add-Content -Path $file -Value "`n- "
    }

    # Open in VS Code
    & $EditorCmd $file
}
