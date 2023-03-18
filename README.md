# Root and Blades

This repository contains all default policies and automation used with Root and Blades projects.

## Testing

The use of `Makefile` has been replaced with [`act`][act]. This can be installed with `brew install act`.

If you are running macOS on a M1+ chip, you must add this to your `~/.zshrc` file to properly build the containers
needed:

```zsh
alias act='act --container-architecture linux/amd64'
```

The following commands are now used for testing:

| Command            | Purpose                                                                      |
|:-------------------|:-----------------------------------------------------------------------------|
| `act pull_request` | Mimic the CI performed during a PR                                           |
| `act create`*      | Mimic the actions performed when a new branch is created (mostly for labels) |

> Items marked with `*` require a GitHub Token to be provided, as described [here][act-token].

Use `act ls` to get a list of all supported workflows with each repository. Please note, some workflows require GitHub
Tokens and, even though they are run locally, can make live updates to Issues and PRs within their respective GitHub
repository. Please be careful when testing and refer to each repository's individual `README.md` file for caveats.

<!-- Link Repository -->

[act]:       https://github.com/nektos/act
[act-token]: https://github.com/nektos/act#github_token
