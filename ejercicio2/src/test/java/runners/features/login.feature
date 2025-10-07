@login
Feature: DemoBlaze Login API Tests

  Background:
    * url baseUrl
    * configure headers = { 'Content-Type': 'application/json' }
    * def credentials = { username: 'testuser_demo', password: 'TestPass123!' }

  Scenario: Login with correct credentials
    Given path 'login'
    And request credentials
    When method post
    Then status 200
    And match response == { "status": "success" }

  Scenario: Login with incorrect password
    Given path 'login'
    And request { "username": "testuser_demo", "password": "wrongpassword" }
    When method post
    Then status 200
    And match response == { "status": "error", "message": "Wrong password." }

  Scenario: Login with non-existent user
    Given path 'login'
    And request { "username": "nonexistentuser12345", "password": "anypassword" }
    When method post
    Then status 200
    And match response == { "status": "error", "message": "User does not exist." }

  Scenario: Login with empty username
    Given path 'login'
    And request { "username": "", "password": "password123" }
    When method post
    Then status 200
    And match response == { "status": "error", "message": "Please fill out Username and Password." }

  Scenario: Login with empty password
    Given path 'login'
    And request { "username": "testuser", "password": "" }
    When method post
    Then status 200
    And match response == { "status": "error", "message": "Please fill out Username and Password." }

  Scenario Outline: Data driven login tests
    Given path 'login'
    And request { "username": "<username>", "password": "<password>" }
    When method post
    Then status 200
    And match response == <expectedResponse>

    Examples:
      | username          | password       | expectedResponse                        |
      | 'testuser_demo'   | 'TestPass123!' | { status: 'success' }                   |
      | 'testuser_demo'   | 'wrong'        | { status: 'error', message: 'Wrong password.' } |
      | 'nonexistent'     | 'any'          | { status: 'error', message: 'User does not exist.' } |
      