#!/bin/bash

root=$(git rev-parse --show-toplevel 2>/dev/null)

fish ${root}/test/test.fish
