module.exports = function(grunt) {
    
    var static_dir = 'root/static/';
    var ia_js_dir = 'src/ia/js/';
    var templates_dir = 'src/templates/';
    var ddgc_js_dir = 'src/ddgc/js/';

    // tasks that run after diff
    // to release a new version
    var release_tasks = [
        'build',
        'exec:version_ia_css',
        'version:release',
        'removelogging',
        'uglify:js',
        'remove',
        'gitcommit:ia_pages'
    ];

    // tasks that run when building
    var build_tasks = [
        'handlebars:compile',
        'compass',
        'concat:ia_pages',
        'concat:ddgc_pages',
        'exec:copy_ddgc_css',
        'exec:copy_ia_css'
    ];

    var ia_page_js = [
        'handlebars_tmp',
        'DDH.js',
        'IAIndex.js',
        'IAPage.js',
        'IAPageCommit.js',
        'ready.js'
    ];

    for( var file in ia_page_js ){
        ia_page_js[file] = ia_js_dir + ia_page_js[file];
    }

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        static_dir: static_dir,
        ia_js_dir: ia_js_dir,
        ddgc_js_dir: ddgc_js_dir,
        templates_dir: templates_dir,

        release_tasks: release_tasks,

        /*
         * increases the version number in package.json
         */
        version: {
            release: {
                options: {
                    release: 'minor'
                },
                src: ['package.json']
            }
        },

        /*
         * concat js files in ia_js_dir and copy to static_dir
         */
        concat: {
            ia_pages:{
                src: [templates_dir+'handlebars_tmp', ia_page_js],
                dest: static_dir + 'js/ia.js'
            },
            ddgc_pages:{
                src: ddgc_js_dir + '*.js',
                dest: static_dir + 'js/ddgc.js'
            }

        },

        /*
         * Compiles handlebar templates and add to Handlebars.templates namespace
         */
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
                    '<%= templates_dir %>/handlebars_tmp' : '<%= templates_dir %>/*.handlebars'
                }
            }
        },

        /*
         * uglify ia.js and give it a version number for release
         */
        uglify: {
            js: {
                files: {
                    '<%= static_dir + "js/ia" +  pkg.version %>.js': static_dir + 'js/ia.js', 
                    '<%= static_dir + "js/ddgc" +  pkg.version %>.js': static_dir + 'js/ddgc.js' 
                }
            }
        },

        remove: {
            default_options: {
                trace: true,
                fileList: [ 
                    static_dir + 'js/ia.js', 
                    templates_dir + 'handlebars_tmp',
                    static_dir + 'js/ddgc.js'
                ]
            }
        },

        /*
         * for release check ia.js to see if it has changed.  If true then
         * run the tasks.  If not then stop here.
         */
        diff: {
            ia_js: {
                src: [ ],
               // src: [ static_dir + 'ia.js'],
                tasks: release_tasks
            }
        },

        /*
         * commits the ia.js version file and package.json
         * still needs to be pushed
         */
        gitcommit: {
            ia_pages: {
                options: {
                    message: 'Release IA pages version: <%= pkg.version %>'
                },
                files: {
                    src: [ 
                        static_dir + 'js/ia<%= pkg.version %>.js', 
                        static_dir + 'js/ddgc<%= pkg.version %>.js', 
                        static_dir + 'css/*',
                        'package.json',  
                    ]
                }
            }
        
        },

        /*
         * removes console.log
         */
        removelogging: {
            dist: {
                src: static_dir + 'js/ia.js'
            }
        },

        compass: {
            dist: {
                options: {
                    ia: {
                        cssDir: 'src/ia/css'
                    },
                    ddgc:{
                        cssDir: 'src/ddgc/css'
                    }
                }
            }
        },

        exec: {
            copy_ddgc_css: {
                command: 'mkdir -p root/static/css && cp -rf src/ddgc/css/* root/static/css/'
            },
            version_ia_css: {
                command: 'mv root/static/css/ia.css root/static/css/ia<%= pkg.version %>.css'
            },
            copy_ia_css: {
                command: 'mkdir -p root/static/css && cp -rf src/ia/css/* root/static/css/'
            }
        }
    });

        grunt.loadNpmTasks('grunt-contrib-concat');
        grunt.loadNpmTasks('grunt-contrib-handlebars');
        grunt.loadNpmTasks('grunt-version');
        grunt.loadNpmTasks('grunt-contrib-uglify');
        grunt.loadNpmTasks('grunt-diff');
        grunt.loadNpmTasks('grunt-remove');
        grunt.loadNpmTasks('grunt-git');
        grunt.loadNpmTasks('grunt-remove-logging');
        grunt.loadNpmTasks('grunt-contrib-compass');
        grunt.loadNpmTasks('grunt-exec');

        // check diff on ia.js.  Diff runs rest
        // of release process if the file has changed
        grunt.registerTask('release', release_tasks);

        // compile handlebars and concat js files
        // to ia.js
        grunt.registerTask('build', build_tasks);
}
