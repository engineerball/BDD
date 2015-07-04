Feature: Go to http://www.engineerball.com and take screenshot
    Scenario: Go to truelife.com
        Given I am at "http://www.engineerball.com"
        And I press "ESC" button for escape pop-up ads
        Then I be able to see text "Damn Those Sweet Memories"
        And Take screenshot on this page
