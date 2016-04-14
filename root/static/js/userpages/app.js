// =========================================================================================================
//
// ANGULAR MAGIC
//
// =========================================================================================================

'use strict';

// var app = angular.module('app', ['ngSanitize', 'textAngular', 'flow']);
var app = angular.module('app', ['ngSanitize']);

// CONTROLLERS

app.controller('IndexController', function() {
    // Empty controller, to prevent errors being thrown
});

// FACTORIES


app.factory('ui', function() {
    return {
        lorem: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Nulla vitae elit libero, a pharetra augue. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Curabitur blandit tempus porttitor.',
        search: '',
        tab: 'Info',
        futuremode: false,
        init: function(search, tab, futuremode) {
            this.search = search;
            this.tab = tab;
            this.futuremode = futuremode;
        }
    };
});
