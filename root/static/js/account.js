$(document).ready(function(){

    if (typeof(userHasLanguages) != "undefined") {
        if (userHasLanguages) {
            $('#btnAddNewLanguage').show();
            $('#formAddUserLanguage').hide();
            $('table.account-table [id^=update_]').hide();
        }
    }

    $('table.account-table select').each(function() {
         $(this).change(function(){
             grade = $('option:selected',this).val();
             language = $(this).attr('id').substring(6);
             href = '?add_user_language=' + language;
             href += '&grade=' + grade;
             $("#update_"+language).fadeIn();
             $("#update_"+language).attr('href', href);
         });
    });

    $('#account-table_ftrLeft').hover(function() {
        $('#gradeReference').fadeIn();
    }, function(){
        $('#gradeReference').fadeOut();
    });
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

function validateFormGravatar() {
    if ($('#gravatar_email').val() == '') {
        $('#error_gravatar_invalid_email').fadeIn();
        return false;
    }
    return true;
}
