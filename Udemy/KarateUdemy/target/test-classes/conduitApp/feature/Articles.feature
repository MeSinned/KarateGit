@parallel=false
Feature: Articles

    Background: Define URL
        * url apiUrl
        * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json') 
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
        * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
        * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body        


    Scenario: Create a new article
        Given path 'articles'
        And request articleRequestBody
        When method Post
        Then status 200
        And match response.article.title == articleRequestBody.article.title

    Scenario: Create and delete article
        Given path 'articles'
        And request articleRequestBody
        When method Post
        Then status 200
        * def articleId = response.article.slug
        * def articleTitle = articleRequestBody.article.title

        Given params { limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title == articleRequestBody.article.title
        
        Given path 'articles',articleId
        When method Delete
        Then status 200

        Given params { limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title != articleRequestBody.article.title

    Scenario: Conditional logic
        Given params { limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        * def favoritesCount = response.articles[0].favoritesCount
        * def article = response.articles[0] 

        #* if (favoritesCount == 0) karate.call('classpath:helpers/AddLikes.feature', article)

        * def result = favoritesCount == 0 ? karate.call('classpath:helpers/AddLikes.feature', article).likesCount : favoritesCount

        Given params { limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].favoritesCount == result

    Scenario: Retry call
        * configure retry = { count: 10, interval: 5000 }

        Given params { limit: 10, offset: 0}
        Given path 'articles'
        And retry until response.articles[0].favoritesCount == 1
        When method Get
        Then status 200

    Scenario: Sleep call
        * def sleep = function(pause){ java.lang.Thread.sleep(pause) }

        Given params { limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        * eval sleep(5000)
        Then status 200

    Scenario: Number to string
        * def foo = 10
        * def json = {"bar": #(foo+'')}
        * match json == {"bar": '10'}

@debug
    Scenario: String to number
        * def foo = '10'
        # * def json = {"bar": #(foo*1)}
        * def json2 = {"bar": #(~~parseInt(foo))}
        # * match json == {"bar": 10}
        * match json2 == {"bar": 10}