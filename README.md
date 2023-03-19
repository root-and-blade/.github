# Root and Blades

This repository contains all default policies and automation used with Root and Blades projects.

## Dependencies

For developers working on this `.github` repository, please perform the following steps to contribute:

1. Clone this repository
2. Install the following dependencies:
    1. [Docker][docker]
    2. [`act`][act]
    3. [`npx`][npx]
    4. [Python3][python]
3. Follow the Caveats below, if running on Apple Silicon (e.g., M1)
4. Install required hooks with the following two commands:

```shell
git lfs install
.github/install-hooks.py
```

While the repository hooks installed with the `install-hooks.py` script are optional, they are extremely important to
ensure that we do not go over our limited budget for CI/CD server minutes with GitHub. Alternatively, you can run
integration tests manually by running:

```shell
act pull_request
```

This mimics the environment and tests that will be run once a Pull Request is opened for your work. This will be run
automatically with `git push` if you install the hook package.

### Caveat for macOS Devices with Apple Silicon (M1) Chips

If you are running macOS on a M1+ chip, you must perform two preliminary steps for these scripts to work, until the
dependencies are updated to work with the new architectures.

First, add this to your `~/.zshrc` file (or `~/.bashrc` file, if you still have not transitioned to ZSH) to properly
build the containers needed:

```zsh
alias act='act --container-architecture linux/amd64'
```

Second, enable this feature in Docker by going to `Settings -> Features in development -> Beta features` (make sure your
Docker install is completely up to date, if you do not see this option):

![Docker Rosetta Feature][docker-rosetta]

Even with these installed, the occasional `VmTracker` issue occurs periodically, which is a virtualization failure.
Running the tests again sometimes resolves these issues. We are still working on a workaround solution for this.

If you believe that you have a clean install, and you have installed this project's pre-push hooks, you can force a push
to CI/CD by the command:

```shell
git push --no-verify
```

This does not bypass the CI/CD pipeline on GitHub, however.

If you run into errors unrelated to normal linting or the occasional `VmTracker` failure, please let the Operations team
know as soon as possible by opening an [Operations Issue][ops-issue] in the appropriate repository.

## Contribution Steps

1. Create a new branch
2. Make your changes
3. Run `npx prettier -uc .` to check for any formatting standard issues (and `npx prettier -uw .` to fix)
4. Run `act pull_request` (if you have not installed the pre-commit hooks)
5. Commit with an informative message
6. Push and create a Pull Request on to the `main` branch

## Testing

The use of `Makefile` has been replaced with [`act`][act]. This better-represents the CI/CD pipelines we use globally.

### Commands

These commands are generally used for testing in each repository, including this one:

| Command            | Purpose                                                                      |
| :----------------- | :--------------------------------------------------------------------------- |
| `act pull_request` | Mimic the CI performed during a Pull Request                                 |
| `act create`\*     | Mimic the actions performed when a new branch is created (mostly for labels) |

> Items marked with `*` require a GitHub Token to be provided, as described [here][act-token].

Running tests any other way (including through the `megalinter-runner` will likely **fail**.

Use `act -l` to get a list of all supported workflows with each repository. Please note, some workflows require GitHub
Tokens and, even though they are run locally, can make live updates to Issues and PRs within their respective GitHub
repository. Please be careful when testing and refer to each repository's individual `README.md` file for caveats.

## License

Copyright &copy; 2023 Root and Blades, LLC. All Rights Reserved.

<!-- Link Repository -->

[act]: https://github.com/nektos/act
[act-token]: https://github.com/nektos/act#github_token
[docker]: https://docker.com
[docker-rosetta]: img/macos-m1-docker-settings.png
[npx]: https://www.npmjs.com/package/npx
[ops-issue]: https://github.com/root-and-blades/.github/issues/new/choose
[python]: https://www.python.org/downloads/
