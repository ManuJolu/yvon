$(document).ready(function() {
  if ($(".sessions.new").length > 0) {
    (function(d, s, id){
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) {return;}
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.com/en_US/messenger.Extensions.js";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'Messenger'));

    window.extAsyncInit = function() {
      MessengerExtensions.getSupportedFeatures(function success(result) {
        console.log(result.supported_features)
        alert(result)
        alert(result.supported_features)
        if (result.supported_features[0] === 'context') {
          $('#webviewLoginForm').show();
        } else {
          $('#websiteLoginForm').show();
        }
      }, function error(err) {
        $('#websiteLoginForm').show();
        alert('fail')
      });
    };
  };

  if ($(".users.show").length > 0) {
    (function(d, s, id){
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) {return;}
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.com/en_US/messenger.Extensions.js";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'Messenger'));

    window.extAsyncInit = function() {
      if (update === 'cc') {
        MessengerExtensions.requestCloseBrowser(function success() {
        }, function error(err) {
        });
      };

      MessengerExtensions.getSupportedFeatures(function success() {
      }, function error(err) {
        $('#nonCreditCard').show();
      });
    };
  };
});


