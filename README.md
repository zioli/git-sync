echo "# git-sync" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:zioli/git-sync.git
git push -u origin main


…or push an existing repository from the command line
git remote add origin git@github.com:zioli/git-sync.git
git branch -M main
git push -u origin main
