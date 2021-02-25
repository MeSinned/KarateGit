
Feature: Hooks

    Background: hooks
        # use 'callonce' to run before all scenarios. eg. same username used in every scenario
        # use 'call' to run before every scenario. eg. new username for each scenario            
        * def result = call read('classpath:helpers/Dummy.feature')
        * def username = result.username

        # after hooks
        # * configure afterFeature = function(){ karate.call('classpath:helpers/Dummy.feature')}
        # * configure afterScenario = function(){ karate.call('classpath:helpers/Dummy.feature')}
        * configure afterFeature =
        """
            function(){
                karate.log('After Feature Text')
            }
        """



    Scenario: First scenario
        * print username
        * print 'This is first scenario'

    Scenario: Second scenario
        * print username
        * print 'This is second scenario'