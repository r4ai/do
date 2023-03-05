function __available_scripts
    set -l cwd (pwd)
    set -l root (git rev-parse --show-toplevel 2>/dev/null)

    if [ -d $root/scripts ]
        for script in (find $root/scripts -type f -name "*.sh")
            set script (basename -s ".sh" "$script")
            echo $script
        end
    end
end

complete -c do -f
complete -c do -s h -l help -x --description "Display help"
complete -c do -n "not __fish_seen_subcommand_from (__available_scripts)" -a "(__available_scripts)"
