Configs
=======

Configuration files, symlink what you need

Automatic:

	run setup_env.sh

Manually:

	Linux:
		ln -s source_file target_dir (use full linux paths)
		ln -s /d/path/file "/c/dir space/user"

	Windows:
		cmd //c "mklink target_file source_file" (use full windows paths)
		cmd //c "mklink "C:\\dir space\\user\\file" D:\path\file"

For .nanorc use https://github.com/Solanar/.nano

git-prompt.sh can be added to /etc/profile.d/ or sourced in .bashrc
