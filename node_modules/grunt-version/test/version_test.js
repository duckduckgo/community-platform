'use strict';

var grunt = require('grunt');

/*
  ======== A Handy Little Nodeunit Reference ========
  https://github.com/caolan/nodeunit

  Test methods:
    test.expect(numAssertions)
    test.done()
  Test assertions:
    test.ok(value, [message])
    test.equal(actual, expected, [message])
    test.notEqual(actual, expected, [message])
    test.deepEqual(actual, expected, [message])
    test.notDeepEqual(actual, expected, [message])
    test.strictEqual(actual, expected, [message])
    test.notStrictEqual(actual, expected, [message])
    test.throws(block, [error], [message])
    test.doesNotThrow(block, [error], [message])
    test.ifError(value)
*/

exports.version = {
  setUp: function(done) {
    done();
  },
  prefix_option: function(test) {
    var files = grunt.config('version.prefix_option.src');
    test.expect(files.length);

    files.forEach(function(file) {
      var content = grunt.file.read(file);
      var actual = /version['"]?\s*[:=] ['"](\d\.\d\.\d)/.exec(content);
      actual = actual && actual[1];

      test.equal(actual, '0.1.0', 'Updates the file with version.');
    });
    test.done();
  },
  release_option: function(test) {
    var files = grunt.config('version.release_option.src');
    test.expect(files.length);

    files.forEach(function(file) {
      var content = grunt.file.read(file);
      var actual = /version['"]?\s*[:=] ['"](\d\.\d\.\d)/.exec(content);
      actual = actual && actual[1];

      test.equal(actual, '0.1.1', 'Increments the version and updates the file.');
    });

    test.done();
  },
  minor: function(test) {
    var files = grunt.config('version.minor.src');
    test.expect(files.length);

    files.forEach(function(file) {
      var content = grunt.file.read(file);
      var actual = /version['"]?\s*[:=] ['"](\d\.\d\.\d)/.exec(content);
      actual = actual && actual[1];

      test.equal(actual, '1.3.0', 'Increments the version and updates the file.');
    });

    test.done();
  },
  literal: function(test) {
    test.expect(2);
    var pkg = grunt.file.readJSON('tmp/test-package-v.json');

    test.equal(pkg.version, '3.2.1', 'Sets package version to literal value');
    test.equal(pkg.devDependencies['grunt-version'], '>=0.1.0', 'Does NOT increment grunt-version');
    test.done();

  }
};
