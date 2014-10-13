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
            ia_pages:{
                src:['js/ia_pages/*.js', 'js/ia_pages/handlebars_tmp'],
                dest: 'root/static/js/ia.js'
            }
        },

        handlebars: {
            compile: {
                options: {
                    namespace: "Handlebars.templates",
                    processName: function(filepath) {
                        var parts = filepath.split('/');
                        return parts[parts.length - 1].replace('.handlebars','');
                    }
                },
                files: {
                    'js/ia_pages/handlebars_tmp' : 'js/ia_pages/*.handlebars'
                }
            }
        },

        uglify: {
            ia_js: {
                files: {
                'root/static/js/ia<%= pkg.version %>.js': 'root/static/js/ia.js' 
            
                }
            }
        },

        remove: {
            default_options: {
                trace: true,
                fileList: ['ia.js'],
                dirList: ['root/static/js/']
            }
        },

       diff: {
            ia_js: {
                src: ['root/static/js/ia.js'],
                tasks: [
                    'uglify:ia_js',
                    'version:release',
                    'remove'
                    ]
            }
        },

    });

        grunt.loadNpmTasks('grunt-contrib-concat');
        grunt.loadNpmTasks('grunt-contrib-copy');
        grunt.loadNpmTasks('grunt-contrib-handlebars');
        grunt.loadNpmTasks('grunt-version');
        grunt.loadNpmTasks('grunt-contrib-uglify');
        grunt.loadNpmTasks('grunt-diff');
        grunt.loadNpmTasks('grunt-remove');

        // check diff on ia.js.  Diff runs rest
        // of release process if the file has changed
        grunt.registerTask('release', [
            'build',
            'diff',
            
            
        ]);

        // compile handlebars and concat js files
        // to root/static/js/ia.js
        grunt.registerTask('build', [
            'handlebars:compile',
            'concat:ia_pages'
        ]);
}
