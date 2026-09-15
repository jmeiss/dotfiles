# Current branch name; used by the push aliases.
detect_git_branch() {
  git branch --show-current 2>/dev/null
}

# GitHub compare link between the latest tag and master, for the current repo.
diff-for-release() {
  git fetch origin || return
  local latest_tag repo
  latest_tag=$(git describe --tags --abbrev=0) || return
  repo=$(git remote get-url origin | sed -E 's#^(git@github\.com:|https://github\.com/)##; s#\.git$##')
  echo "https://github.com/$repo/compare/$latest_tag...master"
}
