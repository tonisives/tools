if [[ "$#" -ne 1 ]]; then
	echo "Specify a commit message as an argument."
	exit 1
fi

COMMIT_MESSAGE="$1"

# tail -r is reversed list. this adds the submodules but not the parent. 
# need to run 2x because parent of submodule is not committed
# maybe the foreach gives a copy and when it goes to parent it doesnt know child is updated
git submodule foreach --recursive "git add . && git commit -m  \"${COMMIT_MESSAGE}\" || :" | tail -r
git submodule foreach --recursive "git add . && git commit -m  \"${COMMIT_MESSAGE}\" || :" | tail -r
git add . && git commit -m "${COMMIT_MESSAGE}" || :

# reset reset
# git submodule foreach --recursive "git reset --soft HEAD~1 || :" | tail -r
