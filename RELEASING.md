# Releasing

Manual desde Actions. Toma ~3–4 min.

## Cómo

1. https://github.com/fintoc-com/fintoc-ruby/actions → **Release** → **Run workflow**.
2. `bump`: `patch` / `minor` / `major`. `release-notes`: markdown opcional.
3. **Run workflow**. Solo corre desde `main`.

## Qué hace

`bundle install` + `rubocop` + `rspec` →
[`release/prepare`](https://github.com/fintoc-com/release-action/tree/main/prepare) bumpea `lib/fintoc/version.rb` (y refresca `Gemfile.lock`) →
`gem build *.gemspec` + `gem push *.gem` (con `RUBYGEMS_API_KEY`) →
[`release/finalize`](https://github.com/fintoc-com/release-action/tree/main/finalize) pushea commit + tag, crea GitHub Release.

Todo autoreado por `fin-releases[bot]`.

## Si falla

| Falla en | Estado | Recovery |
|---|---|---|
| Antes o durante `gem push` | Nada en el remote | Re-run |
| `release/finalize` (post-publish) | Gem en RubyGems, sin tag/release | PR con el commit del bump + `gh release create vX.Y.Z` |
