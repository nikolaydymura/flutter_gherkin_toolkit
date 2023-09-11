Feature: Tab on different buttons

  Scenario: Tap on button by text only
    Given the widget builder by 'home'
    Then tap on text "Increment"
    Then tap on text "Increment"->first
    Then tap on text "Increment"->last
    Then tap on text "Increment"->0
    Then tap on text OutlinedButton->"Increment"
    Then tap on text OutlinedButton->"Increment"->0
    Then tap on text OutlinedButton->"Increment"->first


  Scenario: Tap on button by icon only
    Given the widget builder by 'home'
    Then tap on icon Icons.add

    Given golden file at "golden_1.png"

  Scenario: Tap on button by text only with scrolling
    Given the widget builder by 'home'
    Then scroll -700.0
    Then tap on text "Hello"

  Scenario: Test scrolling
    Given the widget builder by 'second'
    Then scroll -700.0
