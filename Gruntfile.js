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
                src:['js/ia_pages/DDG.js', 'js/ia_pages/IAIndex.js', 'js/ia_pages/IAPage.js', 'ready.js' , 'js/ia_pages/handlebars_tmp'],
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
                fileList: ['root/static/js/ia.js', 'js/ia_pages/handlebars_tmp'],
            }
        },

       diff: {
            ia_js: {
                src: ['root/static/js/ia.js'],
                tasks: [
                    'version:release',
                    'removelogging',
                    'uglify:ia_js',
                    'remove',
                    'gitcommit:ia_pages',
                    ]
            }
        },

        // commits the ia.js version file and package.json
        // still needs to be pushed
        gitcommit: {
            ia_pages: {
                options: {
                    message: 'Release IA pages version: <%= pkg.version %>'
                },
                files: {
                    src: ['root/static/js/ia<%= pkg.version %>.js', 'package.json']
                }
            },
        
        },

        removelogging: {
            dist: {
                src: 'root/static/js/ia.js'
            }
        }

    });

        grunt.loadNpmTasks('grunt-contrib-concat');
        grunt.loadNpmTasks('grunt-contrib-copy');
        grunt.loadNpmTasks('grunt-contrib-handlebars');
        grunt.loadNpmTasks('grunt-version');
        grunt.loadNpmTasks('grunt-contrib-uglify');
        grunt.loadNpmTasks('grunt-diff');
        grunt.loadNpmTasks('grunt-remove');
        grunt.loadNpmTasks('grunt-git');
        grunt.loadNpmTasks('grunt-remove-logging');

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
