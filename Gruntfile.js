module.exports = function(grunt) {
    
    var root_dir = 'root/static/js/';
    var js_dir = 'js/ia_pages/';

    var ia_page_js = [
        'DDH.js',
        'IAIndex.js',
        'IAPage.js',
        'ready.js',
        'handlebars_tmp'
    ];

    for( var file in ia_page_js ){
        ia_page_js[file] = js_dir + ia_page_js[file];
    }

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        root_dir: root_dir,
        js_dir: js_dir,
        
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
                src: ia_page_js,
                dest: root_dir + 'ia.js'
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
               '<%= root_dir + "ia" +  pkg.version %>.js': root_dir + 'ia.js' 
            
                }
            }
        },

        remove: {
            default_options: {
                trace: true,
                fileList: [ root_dir + 'ia.js', js_dir + 'handlebars_tmp'],
            }
        },

       diff: {
            ia_js: {
                src: [ root_dir + 'ia.js'],
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
                    src: [ root_dir + 'ia<%= pkg.version %>.js', 'package.json']
                }
            },
        
        },

        removelogging: {
            dist: {
                src: root_dir + 'ia.js'
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
        // to ia.js
        grunt.registerTask('build', [
            'handlebars:compile',
            'concat:ia_pages'
        ]);
}
