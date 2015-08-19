module.exports = function(grunt) {

    var static_dir = 'root/static/';
    var templates_dir = 'src/templates/';

    // tasks that run after diff
    // to release a new version
    var release_tasks = [
        'build',
        'cssmin:ddgc_css',
        'cssmin:ia_css',
        'removelogging',
        'uglify:js',
        'remove:dev',
        'bump:minor',
    ];

    // commit files for release
    var commit_tasks = [
        'gitcommit'
    ];

    // tasks that run when building
    var build_tasks = [
        'exec:bower',
        'exec:deleteBuildFiles',
        'handlebars:compile',
        'compass',
        'concat',
        'jshint'
    ];

    var ia_page_js = [
        'DDH.js',
        'Helpers.js',
        'IADeprecated.js',
        'IADevPipeline.js',
        'IAIndex.js',
        'IAIssues.js',
        'IAOverview.js',
        'IAPage.js',
        'IAPageCommit.js',
        'ready.js'
    ];

    for(var file in ia_page_js) {
        ia_page_js[file] = "src/js/ia/" + ia_page_js[file];
    }

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        static_dir: static_dir,
        templates_dir: templates_dir,
        release_tasks: release_tasks,

        availabletasks: {
            tasks: {
                options: {
                    filter: 'exclude',
                    tasks: ['compass', 'diff'], // not using this yet
                    groups: {
                        'Utils:': ['watch'],
                        'Build:' : ['handlebars', 'concat'],
                        'Release:' : ['handlebars', 'concat', 'cssmin', 'removelogging', 'uglify', 'remove:dev', 'version'],
                        'Commit:' : ['gitcommit'],
                        'Revert:' : ['exec:revert']
                    }
                }
            }
        },

        /*
         * concat js files in ia_js_dir and copy to static_dir
         */
        concat: {
            ia_pages: {
                src: [templates_dir + 'handlebars_tmp', ia_page_js],
                dest: static_dir + 'js/ia.js'
            },
            ddgc_pages: {
                src: 'src/js/ddgc/*.js',
                dest: static_dir + 'js/ddgc.js'
            },
            ia_css: {
                src: 'build/ia/main.css',
                dest: static_dir + 'css/ia.css'
            },
            ddgc_css: {
                src: 'build/ddgc/main.css',
                dest: static_dir + 'css/ddgc.css'
            },
            content_css: {
                src: 'build/content/main.css',
                dest: static_dir + 'css/content.css'
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

        /*
         * removes dev versions of JS and CSS files
         */
        remove: {
            dev: {
                trace: true,
                fileList: [
                    templates_dir + 'handlebars_tmp',
                    static_dir + 'js/ia.js',
                    static_dir + 'js/ddgc.js',
                    static_dir + 'css/ddgc.css',
                    static_dir + 'css/ia.css'
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
                        static_dir + 'js/ia0.*.0.js',
                        static_dir + 'js/ddgc0.*.0.js',
                        static_dir + 'css/ddgc0.*.0.css',
                        static_dir + 'css/ia0.*.0.css',
                        static_dir + 'css/ddgc.css',
                        'package.json'
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

        /*
         * not used yet
         */
        compass: {
            options: {
                sassDir: 'src/scss',
                cssDir: 'build'
            },
            dist: {
                options: {
                    ia: {
                        cssDir: 'build'
                    },
                }
            }
        },

        /*
         * minify and version css files
         */
        cssmin: {
            ddgc_css: {
                files: {'root/static/css/ddgc<%= pkg.version %>.css' : 'build/ddgc/main.css'}
            },
            ia_css: {
                files: {'root/static/css/ia<%= pkg.version %>.css' : 'build/ia/main.css' }
            }
        },

        /*
         * revert the version number in package.json
         */
        exec: {
            revert: "./script/revert_pkg_version.pl",
            revert_release: "./script/revert_pkg_version.pl release",
            deleteBuildFiles: "rm -r build",
            bower: "bower install"
        },

        watch: {
            scripts: {
                files: ['src/js/ia/*.js', 'src/js/ddgc/*.js'],
                tasks: ['concat']
            },
            templates: {
                files: ['src/templates/*.handlebars'],
                tasks: ['handlebars', 'concat']
            },
            scss: {
                files: ['src/scss/ia/*.scss', 'src/scss/ddgc/*.scss', 'src/scss/content/*.scss', 'src/scss/*.scss'],
                tasks: ['compass', 'concat']
            }
        },

        /*
         * bumps the version number in package.json
         */
        bump: {
            options: {
                files: ['package.json'],
                commit: false,
                createTag: false,
                push: false,
            }
        },

        jshint: {
            options: {
                force: true,
                curly: true,
                eqnull: true,
                browser: true,
                '-W038': false,
                '-W004': false,
                '-W014': false
            },
            files: ia_page_js
        }

    });

        // check diff on ia.js.  Diff runs rest
        // of release process if the file has changed
        grunt.registerTask('release', 'same as build but creates versioned JS and CSS files', release_tasks);

        // compile handlebars and concat js files
        // to ia.js
        grunt.registerTask('build', 'compiles templates, builds JS and CSS files', build_tasks);

        // commit files to the repo for release
        grunt.registerTask('commit', 'commit the versioned files to the repo, still needs to be manually pushed', commit_tasks);

        // default task runs build
        grunt.registerTask('default', build_tasks);

        grunt.registerTask('revert', ['exec:revert']);

        grunt.registerTask('revert-release', ['exec:revert_release']);

        // add modules here
        grunt.loadNpmTasks('grunt-contrib-concat');
        grunt.loadNpmTasks('grunt-contrib-handlebars');
        grunt.loadNpmTasks('grunt-contrib-uglify');
        grunt.loadNpmTasks('grunt-diff');
        grunt.loadNpmTasks('grunt-remove');
        grunt.loadNpmTasks('grunt-git');
        grunt.loadNpmTasks('grunt-remove-logging');
        grunt.loadNpmTasks('grunt-contrib-compass');
        grunt.loadNpmTasks('grunt-contrib-cssmin');
        grunt.loadNpmTasks('grunt-exec');
        grunt.loadNpmTasks('grunt-available-tasks');
        grunt.loadNpmTasks('grunt-bump');
        grunt.loadNpmTasks('grunt-contrib-jshint');
        grunt.loadNpmTasks('grunt-contrib-watch');
}
