#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function previewIt() {
	echo "Preview of file changes:";
	echo "";

	# Find and show diffs for files that will be synced
	find . -type f \
		! -path "./.git/*" \
		! -name ".DS_Store" \
		! -name ".osx" \
		! -name "bootstrap.sh" \
		! -name "README.md" \
		! -name "LICENSE-MIT.txt" \
		| while read -r file; do
			relpath="${file#./}";
			target="$HOME/$relpath";

			if [ -f "$target" ]; then
				if ! diff -q "$file" "$target" > /dev/null 2>&1; then
					echo "=== Modified: $relpath ===";
					diff -u --color "$target" "$file" || true;
					echo "";
				fi;
			else
				echo "=== New file: $relpath ===";
			fi;
		done
}

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	previewIt;

	echo "";
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
