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

The workflow pushes the version commit and tag to `main` before publishing the gem,
then creates the GitHub Release. If it fails:

- At the push (`main` moved): nothing is published. As with the abort above,
  the next release includes the PR, or run the workflow manually.
- After the push, at or before publishing: first check whether the version is on
  RubyGems (`gem list fintoc --remote --exact --all`). The publish step can fail while
  waiting for the gem after it was published; then only the GitHub Release is missing.
  If it is not there, publish it from the tag (`gem build` and `gem push`), or skip
  that version: the next release bumps from it. Re-running the job also bumps,
  so it publishes another version.
- At the GitHub Release: the gem and tag are published.

To create a missing GitHub Release, pass the PR's `## Release notes` with
`gh release create <tag> --notes-file <file>`, or `--generate-notes` if they are empty.
