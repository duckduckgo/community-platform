$(document).ready(function(){
  if(typeof(breadcrumb_right) != "undefined") {
    if (breadcrumb_right == 'language') {
      $('#languageBox').hide();
    }
  }
});

function showLanguageBox() {
  if($('#languageBox').css('display') == 'none') {
    $('#languageBox').slideDown();
    $('#btnChooseLanguage').html('&#9650;');
  } else {
    $('#languageBox').slideUp();
    $('#btnChooseLanguage').html('&#9660;');
  }
  return false;
}
