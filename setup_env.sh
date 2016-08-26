# setup_env.sh
# symlinks dotfiles and other settings files from git repo

echo -e "setting up environment...\n"

# path to this repo
configs="antyc_solutions\projects\configs"

# bash
bash_files=( ".bashrc" ".bash_aliases" )

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
)
is_sublime_installed=true
type sublime >/dev/null 2>&1 || { # this arcane code removes output
	echo -e "sublime not installed"
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

	# bash
	for file in "${bash_files[@]}"
	do
		echo "linking $file..."
		cmd //c mklink "$HOME/$file" "$1\\$configs\Windows\\$file"
	done
	echo "linking .bash_profile..."
	# .bash_profile, required on Windows
	cmd //c mklink "$HOME/.bash_profile" \
		"$1\\$configs\Windows\.bash_profile"
	echo ""

	# nano
	if [[ "$is_nano_installed" = true ]]; then
		echo "linking .nanorc...";
		# .nanorc
		cmd //c mklink "$HOME/.nanorc" "$1\\$configs\.nanorc";
		echo ""
	fi

	# sublime
	if [[ "$is_sublime_installed" = true ]]; then
		sublime_path="$HOME/AppData/Roaming/Sublime Text 3/Packages/User"

		for file in "${sublime_files[@]}"
		do
			echo "linking $file..."
			cmd //c mklink "$sublime_path/$file" \
				"$1\\$configs\Sublime\User\\$file"
		done
		echo ""
	fi
# elif [[ "$OSTYPE" == "" ]]; then # Linux
#	# .bashrc
#	ln -s "$HOME/.bashrc" "$configs/.bashrc"
else
	echo "Unsupported OSTYPE: $OSTYPE"
fi
