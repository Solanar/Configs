# setup_env.sh
# symlinks dotfiles and other settings files from git repo

echo -e "setting up environment...\n"

# path to this repo
projects="antyc_solutions/projects"
configs="$projects/configs-dev/configs"

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
sublime_dictionary_files=(
	"English (Canadian).aff"
	"English (Canadian).dic"
	"English (Canadian).txt"
)
is_sublime_installed=true
type sublime >/dev/null 2>&1 || { # this arcane code removes output
	echo -e "sublime not installed";
	is_sublime_installed=false;
}

echo ""

get_drive() {
	# get the drive that the configs repo is on
	if [[ "$1" ]]; then
		echo -e "Antyc drive: $1\n"
		drive="$1"
	else
		echo "Usage: setup_env [Antyc drive]"
		return 1 # We need to specify the drive on Windows
	fi
}

symlink_bash_files() {
	# symlink_func is a str
	drive="$1"
	symlink_func="$2"
	env_folder="$3"

	# bash
	echo "bash dot files"

	# .bashrc
	file=".bashrc"
	link="$HOME/$file"
	target="$drive/$configs/$env_folder/$file"
	($symlink_func "$file" "$link" "$target")

	# .bash_aliases
	file=".bash_aliases"
	link="$HOME/$file"
	target="$drive/$configs/$file"
	($symlink_func "$file" "$link" "$target")

	# .bash_logout
	file=".bash_logout"
	link="$HOME/$file"
	target="$drive/$configs/$file"
	($symlink_func "$file" "$link" "$target")
}

symlink_django_files() {
	# symlink_func is a str
	drive="$1"
	symlink_func="$2"

	# .django_bash_completion
	echo ".django bash completion"
	file=".django_bash_completion"
	link="$HOME/$file"
	target="$drive/$configs/$file"
	($symlink_func "$file" "$link" "$target")

	echo -e "\n"
}

symlink_python_files() {
	# symlink_func is a str
	drive="$1"
	symlink_func="$2"
	env_folder="$3"

	# python
	echo "python dot files"

	# .pythonrc autocompletion
	file=".pythonrc"
	link="$HOME/$file"
	target="$drive/$configs/$env_folder/$file"
	($symlink_func "$file" "$link" "$target")

	echo -e "\n"
}

symlink_nano_files() {
	# symlink_func is a str
	drive="$1"
	symlink_func="$2"

	# nano
	if [[ "$is_nano_installed" = true ]]; then
		# .nanorc
		echo "nano dot file"
		file=".nanorc"
		link="$HOME/$file"
		target="$drive/$configs/$file"
		($symlink_func "$file" "$link" "$target")

		echo -e "\n"
	fi
}

if [[ "$OSTYPE" == "msys" ]]; then # Windows
	get_drive "$1"
	if [[ $? = 1 ]]; then return 1; fi

	windows_symlink() {
		file="$1"
		link="$2"
		target="$3"
		# TODO: move to .bak if it exists instead?
		if [[ -h "$link" ]]; then
			rm "$link"
		fi
		# echo "linking $file..."
		# convert Linux path / to Windows path \
		#  for some reason only target requires this
		target=${target//\//\\}
		cmd //c mklink "$link" "$target"
	}

	echo -e "linking...\n\n"

	symlink_bash_files "$drive" "windows_symlink" "Windows"

	# .bash_profile, required on Windows
	file=".bash_profile"
	link="$HOME/$file"
	target="$drive/$configs/Windows/$file"
	windows_symlink "$file" "$link" "$target"
	echo -e "\n"

	# .inputrc, for Windows msysgit
	file=".inputrc"
	link="$HOME/$file"
	target="$drive/$configs/Windows/$file"
	windows_symlink "$file" "$link" "$target"

	symlink_django_files "$drive" "windows_symlink"

	symlink_python_files "$drive" "windows_symlink" "Windows"

	symlink_nano_files "$drive" "windows_symlink"

	# sublime
	if [[ "$is_sublime_installed" = true ]]; then
		echo "sublime settings files"
		sublime_path="$HOME/AppData/Roaming/Sublime Text 3/Packages"

		sublime_user_path="$sublime_path/User"
		for file in "${sublime_files[@]}"
		do
			link="$sublime_user_path/$file"
			target="$drive/$configs/Sublime/User/$file"
			windows_symlink "$file" "$link" "$target"
		done
		echo ""

		# sublime dictionary
		sublime_dictionary_path="$sublime_path/Dictionaries"
		if [[ ! -d "$sublime_dictionary_path" ]]; then
			mkdir "$sublime_dictionary_path"
		fi
		if [[ ! -d "$drive/$projects/Dictionaries" ]]; then
			echo "Could not find Dictionaries repo"
		else
			echo "sublime dictionary files"
			for file in "${sublime_dictionary_files[@]}"
			do
				link="$sublime_dictionary_path/$file"
				target="$drive/$projects/Dictionaries/$file"
				windows_symlink "$file" "$link" "$target"
			done
		fi
		echo -e "\n"
	fi
elif [[ "$OSTYPE" == "linux-gnu" ]]; then # Linux
	get_drive "$1"
	if [[ $? = 1 ]]; then return 1; fi

	linux_symlink() {
		file="$1"
		link="$2"
		target="$3"
		# TODO: move to .bak if it exists instead?
		if [[ -h "$link" ]]; then
			rm "$link"
		fi
		# echo "linking $file..."
		ln -sv "$target" "$link"
	}

	echo -e "linking...\n\n"

	symlink_bash_files "$drive" "linux_symlink" "Linux"

	echo -e "\n"

	symlink_django_files "$drive" "linux_symlink"

	symlink_nano_files "$drive" "linux_symlink"
else
	echo "Unsupported OSTYPE: $OSTYPE"
fi

echo "done"
