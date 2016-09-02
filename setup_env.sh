# setup_env.sh
# symlinks dotfiles and other settings files from git repo

echo -e "setting up environment...\n"

# path to this repo
configs="antyc_solutions\projects\configs-dev\configs"

# nano
is_nano_installed=true
type nano >/dev/null 2>&1 || { # this arcane code removes output
	echo -e "nano not installed";
	is_nano_installed=false;
}

# sublime
sublime_files=(
	"Preferences.sublime-settings"
	"GitGutter.sublime-settings"
	"PythonBreakpoints.sublime-settings"
	"Anaconda.sublime-settings"
)
is_sublime_installed=true
type sublime >/dev/null 2>&1 || { # this arcane code removes output
	echo -e "sublime not installed";
	is_sublime_installed=false;
}

echo ""

if [[ "$OSTYPE" == "msys" ]]; then # Windows
	# get the drive that the configs repo is on
	if [[ "$1" ]]; then
		echo -e "Antyc drive: $1\n"
	else
		echo "Usage: setup_env [Antyc drive]"
		return 1 # We need to specify the drive on Windows
	fi

	windows_symlink() {
		file="$1"
		link="$2"
		target="$3"
		# TODO: move to .bak if it exists instead?
		rm "$link" # easier to just rm if it exists
		# echo "linking $file..."
		cmd //c mklink "$link" "$target"
	}

	# bash
	# .bashrc
	file=".bashrc"
	link="$HOME/$file"
	target="$1\\$configs\Windows\\$file"
	windows_symlink "$file" "$link" "$target"
	# .bash_aliases
	file=".bash_aliases"
	link="$HOME/$file"
	target="$1\\$configs\\$file"
	windows_symlink "$file" "$link" "$target"
	# .bash_profile, required on Windows
	file=".bash_profile"
	link="$HOME/$file"
	target="$1\\$configs\Windows\\$file"
	windows_symlink "$file" "$link" "$target"
	echo ""

	# nano
	if [[ "$is_nano_installed" = true ]]; then
		# .nanorc
		file=".nanorc"
		link="$HOME/$file"
		target="$1\\$configs\\$file"
		windows_symlink "$file" "$link" "$target"
		echo ""
	fi

	# sublime
	if [[ "$is_sublime_installed" = true ]]; then
		sublime_path="$HOME/AppData/Roaming/Sublime Text 3/Packages/User"

		for file in "${sublime_files[@]}"
		do
			link="$sublime_path/$file"
			target="$1\\$configs\Sublime\User\\$file"
			windows_symlink "$file" "$link" "$target"
		done
		# echo "" # uncomment if adding more symlinks
	fi
# elif [[ "$OSTYPE" == "" ]]; then # Linux
#	# .bashrc
#	ln -s "$HOME/.bashrc" "$configs/.bashrc"
else
	echo "Unsupported OSTYPE: $OSTYPE"
fi
