$(document).ready(function(){
  if (typeof(userHasLanguages) != "undefined") {
      if (userHasLanguages) {
        $('#btnAddNewLanguage').show();
        $('#formAddUserLanguage').hide();
      }
  }
});

function showFormAddUserLanguage() {
    $('#formAddUserLanguage').fadeIn();
    $('#btnAddNewLanguage').fadeOut();
}

function validateFormAddUserLanguage() {
    selectedLanguage=$('#language_id :selected').text().substring(16,21);
    if ($.inArray(selectedLanguage, userLanguages) != -1) {
      return false;
    }
    return true;
}
