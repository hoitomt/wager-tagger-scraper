var page = require('webpage').create();
page.open('https://www.sportsbook.ag/login', function(status) {
  var blackbox = page.evaluate(function() {
    return document.getElementById('blackbox').value;
  })
  console.log(blackbox);
  phantom.exit();
});