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
                src:['js/ia_pages/*.js', 'js/ia_pages/handlebars_tmp'],
                dest: 'root/static/js/ia-<%= pkg.version %>.js'
            }
        },

        handlebars: {
            compile: {
                options: {
                    namespace: false
                },
                files: {
                    'js/ia_pages/handlebars_tmp' : 'js/ia_pages/*.handlebars'
                }
            }
        },

        uglify: {
            my_target: {
                files: {
                'root/static/js/ia-<%= pkg.version %>.js': 'root/static/js/ia-<%= pkg.version %>.js' 
            
                }
            }
        },

      /*  diff: {
            javascript: {
                src: ['js/ia_pages/*.js'],
                tasks: [
                    'version:release', 
                    'handlebars:compile',
                    'concat:dist',
                    'uglify'
                    ]
            }
        }*/

    });

        grunt.loadNpmTasks('grunt-contrib-concat');
        grunt.loadNpmTasks('grunt-contrib-copy');
        grunt.loadNpmTasks('grunt-contrib-handlebars');
        grunt.loadNpmTasks('grunt-version');
        grunt.loadNpmTasks('grunt-contrib-uglify');
        grunt.loadNpmTasks('grunt-diff');

        grunt.registerTask('release', [
            'handlebars:compile',    
            'concat:dist',
            //'uglify',
            'version:release',

        ]);


        grunt.registerTask('build', [
            'handlebars:compile',
            'concat:dist'
        ]);
}
