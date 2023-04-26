
param(
    [Parameter(Mandatory=$true)]
    [string]$RepoName,
    [string]$ProjectDir = ".",
    [string]$Name
)

# Combine the current working directory with the repository name
$RepoPath = [IO.Path]::Combine($pwd, $RepoName)

# Define the path for locally installed packages to be uploaded to artifacts
$PackagePath = Join-Path -Path $RepoPath -ChildPath "package"

# Get the Maven local repository path
$MavenLocalRepoPath = mvn help:evaluate -Dexpression="settings.localRepository" -q -DforceStdout

# Define the path for the local 51degrees Maven repository
$MavenLocal51DPath = Join-Path -Path $MavenLocalRepoPath -ChildPath "com\51degrees"

# Display the repository path and enter it
Write-Output "Entering '$RepoPath'"
Push-Location $RepoPath

try {
    # Copy the content of the package path to the Maven local repository
    Copy-Item -Path $PackagePath -Destination (Join-Path -Path $MavenLocalRepoPath -ChildPath "com") -Recurse

    # Rename the folder in the Maven local repository
    Rename-Item -Path (Join-Path -Path $MavenLocalRepoPath -ChildPath "com\package") -NewName "51degrees"

    # Display the content of the local 51degrees Maven repository
    Write-Output "Content of the local 51d Maven Repository: "
    Get-ChildItem $MavenLocal51DPath
}
finally {
    # Leave the repository path and display it
    Write-Output "Leaving '$RepoPath'"
    Pop-Location
}

# Exit the script with the last exit code
exit $LASTEXITCODE
