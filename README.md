# Root and Blades

This repository contains all default policies and automation used with Root and Blades projects.

## Dependencies

For developers working on this `.github` repository, please ensure you do the following prior to making a contribution:

1. Clone this repository
2. Ensure both [Docker][docker] and [`act`][act] are installed on the system (`npx` is helpful for some things, as well)
3. Update your settings, as described below, if running on Apple Silicon
4. Install the hooks for this repository by running:

```shell
./.github/install-hooks.sh
```

This will ensure that you are following the standards of this repository prior to uploading to the R&B repository
(saving you time and the company money!). You can run the install hooks script as many times as you wish, and it will
ensure that any existing hooks are maintained.

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

```bash
git push --no-verify
```

If you run into errors unrelated to normal linting or the occasional `VmTracker` failure, please let the Operations team
know as soon as possible by opening an [Operations Issue][ops-issue] in the appropriate repository.

## Contribution Steps

1. Make your changes
2. Run `npx prettier -uc .` to check for any formatting standard issues
3. Run `act pull_request` (if you have not installed the pre-commit hooks)
4. Commit with an informative message
5. Push and PR!

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
[ops-issue]: https://github.com/root-and-blades/.github/issues/new/choose
