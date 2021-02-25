@ignore
Feature: work with DB

    Background:
        * def dbHandler = Java.type('helpers.DbHandler')

    Scenario: Seed database with a new Job
        * eval dbHandler.addNewJobWithName("Job123")

    Scenario: Get level for job
        * def level = dbHandler.getMinAndMaxLevelsForJob("Job123")
        * print level.minLvl
        * print level.maxLvl
        And match level.minLvl == '50'
        And match level.maxLvl == '100'