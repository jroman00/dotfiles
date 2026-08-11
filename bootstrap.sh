#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function previewIt() {
	echo "Preview of file changes:";
	echo "";

	# Find and show diffs for files that will be synced
	find . -type f \
		! -path "./.git/*" \
		! -path "./.claude/CLAUDE.md" \
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

	# Preview composed CLAUDE.md (public + private)
	local private_dir="$HOME/dotfiles-private"
	local public_claude=".claude/CLAUDE.md"
	local private_claude="$private_dir/CLAUDE_PRIVATE.md"
	local dest="$HOME/.claude/CLAUDE.md"

	if [ -f "$private_claude" ]; then
		composed=$(cat "$public_claude"; printf '\n---\n\n<!-- Private content below — do not edit directly, sourced from dotfiles-private -->\n\n'; cat "$private_claude")
	else
		composed=$(cat "$public_claude")
	fi

	if [ -f "$dest" ]; then
		if ! echo "$composed" | diff -q - "$dest" > /dev/null 2>&1; then
			echo "=== Modified: .claude/CLAUDE.md (composed: public + private) ===";
			echo "$composed" | diff -u --color "$dest" - || true;
			echo "";
		fi;
	else
		echo "=== New file: .claude/CLAUDE.md (composed: public + private) ===";
	fi
}

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".claude/CLAUDE.md" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

function doPrivate() {
	local private_dir="$HOME/dotfiles-private"
	local public_claude="$(dirname "${BASH_SOURCE}")/.claude/CLAUDE.md"
	local private_claude="$private_dir/CLAUDE_PRIVATE.md"
	local dest="$HOME/.claude/CLAUDE.md"

	mkdir -p "$HOME/.claude"

	if [ -d "$private_dir/.git" ]; then
		git -C "$private_dir" pull origin main 2>/dev/null
	else
		git clone git@github.com:jroman00/dotfiles-private.git "$private_dir" 2>/dev/null
	fi

	if [ -f "$private_claude" ]; then
		{
			cat "$public_claude"
			printf '\n---\n\n<!-- Private content below — do not edit directly, sourced from dotfiles-private -->\n\n'
			cat "$private_claude"
		} > "$dest"
	else
		cp "$public_claude" "$dest"
	fi
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
	doPrivate;
else
	previewIt;

	echo "";
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
		doPrivate;
	fi;
fi;
unset doIt;
unset doPrivate;
