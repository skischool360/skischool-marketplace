$(document).ready(function() {

  ga(function(tracker) {
    var clientId = tracker.get('clientId');
    $('.ga-client-id').val(clientId);
    console.log("GA clientID is "+clientId)
  });
});
