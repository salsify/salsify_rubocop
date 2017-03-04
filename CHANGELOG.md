# salsify_rubocop

## v0.47.1
- Add `Salsify/StyleDig` cop to recommend using `#dig` for deeply nested access.

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
