# salsify_rubocop

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
