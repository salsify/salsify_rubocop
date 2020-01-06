# salsify_rubocop

## v0.78.0
- Upgrade to `rubocop` v0.78.0
- Upgrade to `rubocop_rspec` v1.37.0
- Add `rubocop-rails `v2.4.0`
- Add `rubocop-performance `v1.5.0`
- Update names/namespaces of rules that changed between 0.62 and 0.78

## v0.62.0
- Upgrade to `rubocop` v0.62.0
- Upgrade to `rubocop_rspec` v1.31.0

## v0.60.0.1
- Upgrade to `rubocop_rspec` v1.30.1

## v0.60.0
- Upgrade to `rubocop` v0.60.0

## v0.59.2.1
- Update `rubocop` to v0.59.2.
- Add `Salsify/RailsUnscoped` cop.

## v0.58.0
- Update `rubocop` to v0.58.0.
- Update `rubocop-rspec` to v1.29.0.
- Adjust Ruby version configuration in `Salsify/StyleDig` spec.

## v0.52.1.1
- Fix `Salsify/StyleDig` false positive in assignments (see [#20](https://github.com/salsify/salsify_rubocop/issues/20)).

## v0.52.1
- Update to `rubocop` v0.52.1 and `rubocop-rspec` v1.21.0.

## v0.48.1
- Add `Salsify/RailsApplicationMailer` cop.

## v0.48.0
- Add `Salsify/RspecDotNotSelfDot` cop.
- Add `Salsify/RailsApplicationSerializer` cop.
- Update to `rubocop` v0.48.1 and `rubocop-rspec` v1.15.0.
- Disable cops: `Lint/AmbiguousBlockAssociation`, `Style/PercentLiteralDelimiters`,
  and `Style/SymbolArray`.

## v0.47.2
- Fix issue for `Salsify/Style` with nested access as the target for
  conditional assignment.

## v0.47.1
- Add `Salsify/StyleDig` cop to recommend using `#dig` for deeply nested access.
- Add `Salsify/RailsApplicationRecord` cop.
- Add new `rubocop_rails50` configuration for use with Rails 5.0 apps.

## v0.47.0
- Update to `rubocop` v0.47.1 and `rubocop-rspec` v1.10.0.
- Enable `Bundler/OrderedGems` now that auto-correct is supported.
- Disable new cop `Rails/FilePath`.
- Disable `RSpec/MessageExpectation` and use `RSpec/MessageSpies` instead.
- Add `DisplayCopNames: true` default for `AllCops`.

## v0.46.0
- Update to `rubocop` v0.46.0.
- Disable new cops: `Bundler/OrderedGems` and `Style/EmptyMethod`.
- Disable cops: `Style/MultilineBlockChain` and `Style/SingleLineBlockParams`.

## v0.45.0
- Update to `rubocop` v0.45.0 and `rubocop-rspec` v1.8.0.
- Explicitly enable `Rspec/MessageExpectation` cop that is now disabled
  by default.

## v0.44.0
- Update to `rubocop` v0.44.1.
- Disable new cops: `Metrics/BlockLength` and
  `Rails/HttpPositionalArguments`.

## v0.43.0
- Update to `rubocop` v0.43.0.
- Update to `rubocop-rspec` v1.7.0.
- Disable new RSpec cops: `LeadingSubject`, `LetSetup`, `MultipleExpectations`,
  and `NestedGroups`.
- Disable new cop `RSpec/ExpectActual` for routing specs.
- Disable problematic cops `Style/NumericPredicate`, `Style/SafeNavigation`,
  and `Style/VariableNumber`.
- Disable `Style/IndentHash`, which applies to the first line, since we are not
  using `Style/AlignHash`.
- Add `Salsify/RspecStringLiterals` cop to check non-doc string quotes for
  examples/example groups.
- Modify `Salsify/RspecDocString` to treat names for shared groups and shared
  example as doc strings.

## v0.42.0
- Update to RuboCop v0.42.
- Add `Salsify/RspecDocString` cop to check quoting for examples/example groups.

## v0.41.0
- `.ruby-version` can be used to determine TargetRubyVersion in RuboCop v0.41
- Change to `rubocop_rails` configuration:
        Rails/UniqBeforePluck:
          EnforcedMode: aggressive

- Changes to `rubocop_without_rspec` configuration:
        Style/EachForSimpleLoop:
          AutoCorrect: false

        Style/ModuleFunction:
          EnforcedStyle: extend_self

        Style/NumericLiteralPrefix:
          Enabled: false

## v0.40.1
- Changes to `rubocop_without_rspec` configuration:

        Performance/RedundantMerge:
          MaxKeyValuePairs: 1

        Style/ModuleFunction:
          Enabled: false

        Style/RaiseArgs:
          EnforcedStyle: compact

## v0.40.0
- Initial version
