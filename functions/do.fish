#!/usr/bin/env fish
# -*-  mode:fish; tab-width:4  -*-

function do
    # * Parse arguments
    argparse -n do \
        h/help \
        -- $argv or return

    # * Get root directory of git repository
    set -l cwd (pwd)
    set -l root (git rev-parse --show-toplevel 2>/dev/null)

    if set -ql _flag_help
        echo "Usage: do <script>"
        echo ""
        echo "Run a script in the `scripts` directory of the current git repository."
        echo ""
        echo "Options:"
        echo "  -h, --help  Show this help message and exit"
        echo ""
        echo "Example:"
        echo "  \$ tree"
        echo "  ."
        echo "  ├── README.md"
        echo "  └── scripts"
        echo "      ├── build.sh"
        echo "      └── test.sh"
        echo ""
        echo "  \$ do build"
        echo "  Building..."
        echo ""
        return 0
    else
        # * Check if in git repository
        if [ "$root" = "" ]
            echo "Not in a git repository."
            echo "You need to be in a git repository to use this script."
            echo ""
            echo "Usage: do <script>"
            return 1
        end

        # * Get list of script file paths in scripts directory
        set -l scripts
        if [ -d $root/scripts ]
            for script in (find $root/scripts -type f -name "*.sh")
                set script (basename -s ".sh" "$script")
                set scripts $scripts $script
            end
            set scripts (echo $scripts | tr " " "\n" | sort)
        else
            set scripts ""
        end

        # * Run script if it exists
        if [ -d $root/scripts ]
            if [ -f "$root/scripts/$argv[1].sh" ]
                eval "$root/scripts/$argv[1].sh"
            else
                echo "Available scripts: $scripts"
            end
        else
            echo "No scripts directory found"
        end

        return 0
    end
end
