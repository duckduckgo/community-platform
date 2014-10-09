module.exports = function(grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        version: {
            release: {
                options: {
                    release: 'minor'
                },
                src: ['package.json']
            }
        },

        concat: {
            dist:{
                src:['js/ia.js', 'js/handlebars_tmp'],
                dest: 'root/static/js/ia.js'
            }
        },

        handlebars: {
            compile: {
                files: {
                    'js/handlebars_tmp' : 'js/*.handlebars'
                }
            }
        },

        uglify: {
            my_target: {
                files: {
                    'root/static/js/ia<%= pkg.version %>.js' : ['root/static/js/ia.js']
                }
            }
        }
    });

        grunt.loadNpmTasks('grunt-contrib-concat');
        grunt.loadNpmTasks('grunt-contrib-handlebars');
        grunt.loadNpmTasks('grunt-version');
        grunt.loadNpmTasks('grunt-contrib-uglify');

        grunt.registerTask('release', [
            'version:release',
            'handlebars:compile',    
            'concat:dist',
            'uglify'
        ]);

        grunt.registerTask('build', [
            'handlebars:compile',
            'concat:dist'
        ]);
}
