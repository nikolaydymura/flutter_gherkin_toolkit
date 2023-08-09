# Comment
Feature: Addition

  @tag

  Scenario: successful login
    Given I type `my@email.com` into email
    Given I type `qwerty` into password
    Then I tap on text TextButton->`button`
    Then I tap on text TextButton->`button`->12
    Then I tap on widget TextButton->Icons.add->12
    Then I tap on widget TextButton->last
    Then I tap on widget Container->TextButton->last
    Then I tap on text `button`->12
    Then I tap on text `button`
    When I tap on login button
    Then I should see `Welcome` message
    Then I tap on icon `Icons.add`
    Then I tap on icon `Icons.delete`
    Then I tap on icon `Icons.add`->2
    Then I tap on icon TextButton->`Icons.add`->2
    Then I tap on image `Image.asset("assets/images/arrow_back.png")`
    Then I tap on image `assets/images/arrow_back1.svg`
    Then I tap on image `assets/images/arrow_back4.jpeg`

