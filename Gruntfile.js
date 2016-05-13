var os = require('os');

module.exports = function(grunt) {
    require('load-grunt-tasks')(grunt);

    var static_dir = 'root/static/';
    var templates_dir = 'src/templates/';

    // Set proxy for the live reload assets, i.e., livereload.js
    var reload = {
	livereload: {
	    host: os.hostname(),
	    port: 5000
	}
    };

    // Libraries that we need.
    var moment = 'bower_components/moment/min/moment.min.js';
    var charts = 'bower_components/Chart.js/Chart.min.js';

    // Tasks running when testing.
    var test_tasks = [
        'exec:tests'
    ];

    // Tasks that run when releasing.
    var release_tasks = [
	'gitrm:old_releases',
        'build_release',
        'cssmin:ddgc_css',
        'cssmin:ia_css',
        'removelogging',
        'uglify:js',
	'concat:libs_release',
        'remove:dev',
        'bump:minor',
    ];

    // Commit files for release.
    var commit_tasks = [
        'exec:commit_static'
    ];

    // Short-hand for the common concat tasks.
    // This doesn't include the libraries because the 
    // inclusion of those depends on the kind of build.
    var concat_css = [
        'concat:ia_css',
        'concat:ddgc_css',
        'concat:content_css'
    ];

    var concat_js = [
	'concat:ia_pages',
        'concat:ddgc_pages'
    ];

    // Tasks that run when building.
    var build_tasks = [
        'exec:bower',
        'exec:deleteBuildFiles',
        'handlebars:compile',
        'sass',
	'concat_js',
	'concat:libs_build',
	'concat_css',
        'jshint'
    ];

    var build_tasks_release = [
        'exec:bower',
        'exec:deleteBuildFiles',
        'handlebars:compile',
        'sass',
	'concat_js',
	'concat_css',
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
        'IAPageNew.js',
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
                    tasks: ['sass', 'diff'],
                    groups: {
                        'Utils:': ['watch'],
                        'Commit:' : ['exec:commit_static'],
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
            },
	    libs_build: {
		src: [static_dir + 'js/ia.js', moment, charts],
		dest: static_dir + 'js/ia.js'
	    },
	    libs_release: {
                src: ['<%= static_dir + "js/ia" +  pkg.version %>.js', moment, charts],
                dest: '<%= static_dir + "js/ia" +  pkg.version %>.js'
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
         * Uglify ia.js and ddgc.js and give it a version number for release.
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
         * Removes dev versions of JS and CSS files
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

	gitrm: {
            old_releases: {
                options: { 
                    force: 'true'
                },
                files: {
                    src: [
                        static_dir + 'js/ia0.*.0.js',
                        static_dir + 'js/ddgc0.*.0.js',
                        static_dir + 'css/ddgc0.*.0.css',
                        static_dir + 'css/ia0.*.0.css'
                    ]
                }
            }
        },

        gitadd: {
            options: {
                force: 'true'
            },
            files: {
                src: [
                    static_dir + 'js/ia0.*.0.js',
                    static_dir + 'js/ddgc0.*.0.js',
                    static_dir + 'css/ddgc0.*.0.css',
                    static_dir + 'css/ia0.*.0.css',
                    static_dir + 'css/content.css'
                ]
            }
        },

        /*
         * For release check ia.js to see if it has changed. If true then
         * run the tasks. If not then stop here.
         */
        diff: {
            ia_js: {
                src: [ ],
		// src: [ static_dir + 'ia.js'],
                tasks: release_tasks
            }
        },

        /*
         * Removes console.log
         */
        removelogging: {
            dist: {
                src: static_dir + 'js/ia.js'
            }
        },

        /*
         * Build Sass files.
         */
	sass: {
	    dist: {
		files: {
		    'build/ia/main.css': 'src/scss/ia/main.scss',
		    'build/ddgc/main.css': 'src/scss/ddgc/main.scss',
		    'build/content/main.css': 'src/scss/content/main.scss',
		}
	    }
	},

        /*
         * Minify and version CSS files.
         */
        cssmin: {
            ddgc_css: {
                files: {'root/static/css/ddgc<%= pkg.version %>.css' : 'build/ddgc/main.css'}
            },
            ia_css: {
                files: {'root/static/css/ia<%= pkg.version %>.css' : 'build/ia/main.css' }
            }
        },

        exec: {
            revert: "./script/revert_pkg_version.pl",
            revert_release: "./script/revert_pkg_version.pl release",
            deleteBuildFiles: "mkdir -p build && rm -r build",
            bower: "bower install",
	        commit_static: "git add root/static/* package.json && git commit -m 'Release IA pages version: <%= pkg.version %>'",
            tests: "src/t/run.bash"
        },

	// Build again if any of the JS / SCSS files changed.
        watch: {
            scripts: {
                files: ['src/js/ia/*.js', 'src/js/ddgc/*.js'],
                tasks: ['concat_js', 'concat:libs_build'],
		options: reload
            },
            templates: {
                files: ['src/templates/*.handlebars'],
                tasks: ['handlebars', 'concat_js', 'concat:libs_build'],
		options: reload
            },
            scss: {
                files: ['src/scss/ia/*.scss', 'src/scss/ddgc/*.scss', 'src/scss/content/*.scss', 'src/scss/*.scss'],
                tasks: ['sass', 'concat_css'],
		options: reload
            }
        },

        /*
         * Bumps the version number in package.json
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

    grunt.registerTask('test-ia', 'Integration tests for IA Pages.', test_tasks);
    grunt.registerTask('release', 'Same as build but creates versioned JS and CSS files.', release_tasks);
    grunt.registerTask('build', 'Compiles templates, builds JS and CSS files.', build_tasks);
    grunt.registerTask('build_release', 'Compiles templates, builds JS and CSS files for release.', build_tasks_release);
    grunt.registerTask('concat_js', 'Concatenate JS files', concat_js);
    grunt.registerTask('concat_css', 'Concatenate CSS files', concat_css);
    grunt.registerTask('commit', 'commit the versioned files to the repo, still needs to be manually pushed', commit_tasks);
    grunt.registerTask('default', build_tasks);
    grunt.registerTask('revert', ['exec:revert']);
    grunt.registerTask('revert-release', ['exec:revert_release']);
}
