Feature: IncrementBloc
  Tests addition feature of IncrementBloc

  Scenario: Incrementing twice
    When "CounterBloc" add "IncrementEvent"
    When "CounterBloc" add "IncrementEvent"
    And wait 100 milliseconds
    Then "CounterBloc" state is 2

  Scenario: Decrementing twice
    When "CounterBloc" add "DecrementEvent"
    When "CounterBloc" add "DecrementEvent"
    And wait 100 milliseconds
    Then "CounterBloc" state is -2

  Scenario: Decrementing twice
    When "CounterBloc" add "DecrementEvent"
    When "CounterBloc" add "IncrementEvent"
    When "CounterBloc" add "IncrementEvent"
    And wait 100 milliseconds
    Then "CounterBloc" state is 1