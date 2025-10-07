@signup
Feature: DemoBlaze Signup API Tests

  Background:
    * url baseUrl
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario: Create a new user successfully
    Given path 'signup'
    And request { "username": "#(uniqueUsername)", "password": "#(uniquePassword)" }
    When method post
    Then status 200
    And match response == { "status": "success" }
    And def signupUsername = uniqueUsername

  Scenario: Attempt to create an existing user
    Given path 'signup'
    And request { "username": "existing_user", "password": "password123" }
    When method post
    Then status 200
    And match response == { "status": "error", "message": "This user already exist." }

  Scenario: Signup with empty username
    Given path 'signup'
    And request { "username": "", "password": "password123" }
    When method post
    Then status 200
    And match response == { "status": "error", "message": "Please fill out Username and Password." }

  Scenario: Signup with empty password
    Given path 'signup'
    And request { "username": "testuser123", "password": "" }
    When method post
    Then status 200
    And match response == { "status": "error", "message": "Please fill out Username and Password." }

  Scenario: Signup with missing fields
    Given path 'signup'
    And request { }
    When method post
    Then status 200
    And match response == { "status": "error", "message": "Please fill out Username and Password." }