#!/usr/bin/env fish
set is_failure false
set cwd (pwd)
set root (git rev-parse --show-toplevel 2>/dev/null)

function assert
    set expected $argv[1]
    set actual $argv[2]
    if [ "$expected" != "$actual" ]
        echo "ERROR: expected '$expected', got '$actual'"
        set is_failure true
    else
        echo "SUCCESS: expected '$expected', got '$actual'"
    end
end

function del_projects_for_tests
    cd $root/test
    rm -rf project_with_empty_scripts
    rm -rf project_with_scripts
    rm -rf project_without_scripts
end

function gen_projects_for_tests
    cd $root/test
    del_projects_for_tests

    #* project_with_empty_scripts
    mkdir project_with_empty_scripts
    mkdir project_with_empty_scripts/scripts
    cd project_with_empty_scripts && git init && cd ..

    #* project_with_scripts
    mkdir project_with_scripts
    mkdir project_with_scripts/scripts
    echo "echo 'Building...'" >project_with_scripts/scripts/build.sh
    echo "echo 'Testing...'" >project_with_scripts/scripts/test.sh
    echo "echo 'Hello, World!'" >project_with_scripts/scripts/hello.sh
    cd project_with_scripts && git init && cd ..

    #* project_without_scripts
    mkdir project_without_scripts
    cd project_without_scripts && git init && cd ..
end

function run_tests
    echo ""
    echo "=== START TESTS ==="

    # * test project_with_empty_scripts
    set expected "Available scripts: "
    set actual (cd $root/test/project_with_empty_scripts && do)
    assert $expected $actual

    # * test project_with_scripts
    set expected "Available scripts: hello build test"
    set actual (cd $root/test/project_with_scripts && do)
    assert $expected $actual

    set expected "Available scripts: hello build test"
    set actual (cd $root/test/project_with_scripts && do hoge)
    assert $expected $actual

    set expected "Building..."
    set actual (cd $root/test/project_with_scripts && do build)
    assert $expected $actual

    set expected "Testing..."
    set actual (cd $root/test/project_with_scripts && do test)
    assert $expected $actual

    set expected "Hello, World!"
    set actual (cd $root/test/project_with_scripts && do hello)
    assert $expected $actual

    # * test project_without_scripts
    set expected "No scripts directory found"
    set actual (cd $root/test/project_without_scripts && do)
    assert $expected $actual

    # * reset to original directory
    cd $cwd

    echo "=== END TESTS ==="
    echo ""
end

gen_projects_for_tests
run_tests
del_projects_for_tests
cd $cwd

if $is_failure
    echo "Some tests failed!"
    exit 1
else
    echo "All tests passed!"
    exit 0
end
