Feature: IncrementBloc
  Tests the addition feature of the IncrementBloc

  Scenario: Incrementing twice
    When add "Increment" event
    When add "Increment" event
    Then the state is 2

  Scenario: Decrementing twice
    When add "Decrement" event
    When add "Decrement" event
    When add "CDecrement" event with 2
    Then the state is -2

  Scenario: Decrementing twice
    When add "Decrement" event
    When add "Increment" event
    When add "Increment" event
    Then the state is 1