function shareToFacebook(url, title, desc) {
  var sharedUrl = "https://m.facebook.com/sharer.php?u="+url+"&title="+title+"&description="+desc;
  var facebookPopup = window.open(sharedUrl, "pop", "scrollbars=no");
  return false;
}

function shareToTwitter(url, title) {
  var sharedUrl = "https://twitter.com/share?&text="+title+"&url="+url+"&via=Third Space";
  var twitterPopup = window.open(sharedUrl, "pop", "scrollbars=no");
  return false;
}

