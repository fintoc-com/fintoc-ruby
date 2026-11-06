# fintoc-ruby

The official Ruby SDK for the Fintoc API.

## Skills

Edit skills in `.agents/skills/`; `.claude/skills` links there.
Use `add-api-resource` when adding or updating API resources,
actions, or fields, including its offline test instructions.

## Releases

Merging a PR to `main` with a `release:patch`, `release:minor` or `release:major`
label publishes a release; notes come from the PR's `## Release notes` section.
If `main` has other commits after the merged PR, the release aborts before publishing;
the next release includes it. The `release` workflow can also be run manually.
Keep version bumps separate from feature changes.
