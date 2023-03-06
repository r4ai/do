# Simple command to run scripts

## Usage

```bash
$ do [script-file-name]
```

`do` finds the script files with `sh` extension in `scripts` directory and run it.  
The `[script-file-name]` is the name of the shell script file without the extension.

For example, if you're in the project like this:

```bash
$ pwd
~/my-project

$ tree
.
├── scripts/
│   ├── build.sh
│   ├── deploy.sh
│   └── test.sh
├── src/
└── README.md
```

If you want to run `build.sh`, you can run the following command instead of `./scripts/build.sh`:

```bash
$ do build
```

Because `do` detects the root directory of the project, you can run the command from anywhere in the project.

```bash
# Move to the src directory.
$ cd src

# Run the test. This is the same as `../scripts/test.sh`.
$ do test
```

## Installation

You can install `do` using [fisher](https://github.com/jorgebucaran/fisher).

```bash
fisher install r4ai/do
```

## Development

### How to install from local file

```bash
$ git clone https://github.com/r4ai/do
$ cd do
$ fisher install .
```

### How to run tests

```bash
# This command is the same as `sh ./scripts/test.sh`.
$ do test
```

using [act](https://github.com/nektos/act), you can run GitHub Actions for testing locally.

```bash
$ act
```
