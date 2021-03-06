Feature: Check aliases
  Scenario: Basic syntax #1
    Given a file "basic-example-1" with:
      """
      moin: foo,
            bar,
            baz
      """
    When I successfully run `check-aliases basic-example-1`
    Then the output should contain exactly ""

  Scenario: Invalid syntax #1
    Given a file "invalid-example-1" with:
      """
      moin: foo,
            bar
            baz
      """
    When I run `check-aliases invalid-example-1`
    Then the exit status should be 1
    And the output should contain "syntax error"

  Scenario: Invalid syntax #2
    Given a file "invalid-example-2" with:
      """
      foo: bar,
      baz: moin
      """
    When I run `check-aliases invalid-example-2`
    Then the exit status should be 1
    And the output should contain "syntax error"

  Scenario: Invalid syntax #3
    Given a file "invalid-example-3" with:
      """
      *
      """
    When I run `check-aliases invalid-example-3`
    Then the exit status should be 1
    And the output should contain "Unexpected character: '*'"
