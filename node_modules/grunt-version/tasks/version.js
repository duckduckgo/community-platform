/*
 * grunt-version
 * https://github.com/kswedberg/grunt-version
 *
 * Copyright (c) 2013 Karl Swedberg
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function(grunt) {

  grunt.registerMultiTask('version', 'Update version number in all the files.', function() {
    // Merge task-specific and/or target-specific options with these defaults.
    var options = this.options({
      prefix: '[^\\-]version[\'"]?\\s*[:=]\\s*[\'"]',
      replace: '[0-9a-zA-Z\\-_\\.]+',
      pkg: grunt.config('pkg'),
      release: ''
    });

    if (typeof options.pkg === 'string') {
      options.pkg = grunt.file.readJSON(options.pkg);
    }

    var newVersion,
        release = this.args && this.args[0] || options.release,
        semver = require('semver'),
        version = options.pkg.version,
        bump = /major|minor|patch|build/.test(release),
        literal = /(?:\d\.){2}\d[0-9a-zA-Z\-_\.]*/.test(release);

    if (bump) {
      newVersion = semver.inc(version, release);
    } else if (literal) {
      newVersion = release;
    } else if (release) {
      grunt.log.warn(release + ' must be a valid release name or semver version. Version will not be updated.');
    }

    version = newVersion || version;

    this.filesSrc.forEach(function(filepath) {
      // Warn if a source file/pattern was invalid.
      if (!grunt.file.exists(filepath)) {
        grunt.log.error('Source file "' + filepath + '" not found.');
        return '';
      }
      // Read file source.
      var pattern = new RegExp('(' + options.prefix + ')(' + options.replace + ')', 'g'),
          file = grunt.file.read(filepath),
          newfile = file.replace(pattern, '$1' + version),
          matches = pattern.exec(file);

      if (!matches) {
        grunt.log.subhead('Pattern not found in file');
        grunt.log.writeln('Path: ' + filepath);
        grunt.log.writeln('Pattern: ' + pattern);
      } else {
        grunt.log.subhead('File updated');
        grunt.log.writeln('Path: ' + filepath);
        grunt.log.writeln('Old version: ' + matches.pop() + '. New version: ' + version + '.');
      }
      grunt.file.write(filepath, newfile);
    });

  });

};
