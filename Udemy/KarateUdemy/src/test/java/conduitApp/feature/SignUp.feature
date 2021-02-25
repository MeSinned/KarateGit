
Feature: Sign Up new user

    Background: Preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def timeValidator = read('classpath:helpers/timeValidator.js')        
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()        
        * url apiUrl 

    Scenario: New user Sign Up
        Given path 'users'
        And request
        """
            {
                "user": {
                    "email": #(randomEmail),
                    "password": "equifax789",
                    "username": #(randomUsername)
                }
            }
        """
        When method Post
        Then status 200
        And match response ==
        """
            {
                "user": {
                    "id": '#number',
                    "email": #(randomEmail),
                    "createdAt": '#? timeValidator(_)',
                    "updatedAt": '#? timeValidator(_)',
                    "username": #(randomUsername),
                    "bio": null,
                    "image": null,
                    "token": '#string'
                }
            }
        """

@parallel=false
    Scenario Outline: Validate Sign Up error messages email
        Given path 'users'
        And request
        """
            {
                "user": {
                    "email": "<email>",
                    "password": "<password>",
                    "username": "<username>"
                }
            }
        """
        When method Post
        Then status 422
        And match response == <errorResponse>

        Examples:
            | email               | password   | username          | errorResponse                                        |
            | #(randomEmail)      | equifax789 | equifax789        | {"errors": {"username": ["has already been taken"]}} |
            | equifax789@test.com | equifax789 | #(randomUsername) | {"errors": {"email": ["has already been taken"]}}    |