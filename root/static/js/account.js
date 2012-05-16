$(document).ready(function(){
  if (userHasLanguages) {
    $('#btnAddNewLanguage').show();
    $('#formAddUserLanguage').hide();
  }
});

function showFormAddUserLanguage() {
    $('#formAddUserLanguage').fadeIn();
    $('#btnAddNewLanguage').fadeOut();
}
