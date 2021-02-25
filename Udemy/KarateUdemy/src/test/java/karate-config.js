function fn() {    
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://conduit.productionready.io/api/'
  }

  if (env == 'dev') {
    config.userEmail = 'equifax123@test.com'
    config.userPassword = 'equifax123'
  }
  
  if (env == 'qa') {
    config.userEmail = 'equifax456@test.com'
    config.userPassword = 'equifax456'
  }

  // use 'callSingle' to run before all features
  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}