# Root and Blades

This repository contains all default policies and automation used with Root and Blades projects.

## Dependencies

For developers working on this `.github` repository, please ensure you do the following prior to making a contribution:

1. Clone this repository
2. Ensure both Docker and [`act`][act] are installed on the system
3. Update your settings, as described below, if running on Apple Silicon
4. Install the CI test hook to ensure tests pass before pushing:

```shell
ln -s .github/hooks/pre-push.ci-tests .git/hooks/
```

This will ensure that you are following the standards of this repository prior to uploading to the R&B repository
(saving you time and the company money!).

## Testing

The use of `Makefile` has been replaced with [`act`][act]. This better-represents the CI/CD pipelines we use globally.

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

If you run into errors unrelated to application testing or linting, please let the Operations team know as soon as
possible by opening an [Operations Issue][ops-issue] in this repository.

### Commands

These commands are generally used for testing in each repository, including this one:

| Command            | Purpose                                                                      |
| :----------------- | :--------------------------------------------------------------------------- |
| `act pull_request` | Mimic the CI performed during a Pull Request                                 |
| `act create`\*     | Mimic the actions performed when a new branch is created (mostly for labels) |

> Items marked with `*` require a GitHub Token to be provided, as described [here][act-token].

Use `act ls` to get a list of all supported workflows with each repository. Please note, some workflows require GitHub
Tokens and, even though they are run locally, can make live updates to Issues and PRs within their respective GitHub
repository. Please be careful when testing and refer to each repository's individual `README.md` file for caveats.

<!-- Link Repository -->

[act]: https://github.com/nektos/act
[act-token]: https://github.com/nektos/act#github_token
[docker-rosetta]: img/macos-m1-docker-settings.png
[ops-issue]: https://github.com/root-and-blades/.github/issues/new/choose