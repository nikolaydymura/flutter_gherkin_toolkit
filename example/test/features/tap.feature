Feature: Tab on different buttons

  Scenario: Tab on button by text only
    Given the widget builder by 'home'
    Then tap on text "Increment"
    Then tap on text "Increment"->first
    Then tap on text "Increment"->last
    Then tap on text "Increment"->0
    Then tap on text OutlinedButton->"Increment"
    Then tap on text OutlinedButton->"Increment"->0
    Then tap on text OutlinedButton->"Increment"->first


  Scenario: Tab on button by icon only
    Given the widget builder by 'home'
    Then tap on icon Icons.add
    Given golden file at "golden_1.png"