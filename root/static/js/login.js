function validateFormLogin() {
    console.log($('#username'));
    if ($('#username').val() === '' || $('#password').val() === '') {
        $('#invalidForm').fadeIn();
        return false;
    }
    return true;
}
