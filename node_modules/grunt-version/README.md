# grunt-version

[Grunt][grunt] task to handle versioning of a project.

## Getting Started
_Requires grunt 0.4. If you haven't used [grunt][] before, be sure to check out the [Getting Started][] guide._

From the same directory as your project's [Gruntfile][Getting Started] and [package.json][], install this plugin by running the following command:

```bash
npm install grunt-version --save-dev
```

Once that's done, add this line to your project's Gruntfile:

```js
grunt.loadNpmTasks('grunt-version');
```

If the plugin has been installed correctly, running `grunt --help` at the command line should list the newly-installed plugin's task. In addition, the plugin should be listed in package.json as a `devDependency`, which ensures that it will be installed whenever the `npm install` command is run.

[grunt]: http://gruntjs.com/
[Getting Started]: https://github.com/gruntjs/grunt/blob/devel/docs/getting_started.md
[package.json]: https://npmjs.org/doc/json.html

## The "version" task

### Overview
In your project's Gruntfile, add a section named `version` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  version: {
    options: {
      // Task-specific options go here.
    },
    your_target: {
      // Target-specific file lists and/or options go here.
    },
  },
})
```

### Options

#### options.pkg
Type: `Object`
Default value: `grunt.config('pkg')`

An object representing a parsed package file. By default, `grunt-version` will check Gruntfile.js for something like this:

```js
grunt.initConfig({
  // ...
  pkg: grunt.file.readJSON('package.json'),
  // ...
});
```

This object is where your "canonical" version should be set, in a `"version"` property, naturally. The `grunt-version` plugin uses that version (either incremented by the `release` option or not) when it updates version info in other files.

#### options.prefix
Type: `String`
Default value: `'[^\\-]version[\'"]?\\s*[:=]\\s*[\'"]'`

A string value representing a regular expression to match text preceding the actual version within the file.

#### options.release
Type: `String`
Default value: `''`

A string value representing one of the `semver` release types ('major', 'minor', 'patch', or 'build') used to increment the value of the specified package version.

### Usage Examples

#### Default Options
In this example, the default options are used to update the version in `src/testing.js` and `src/123.js` based on the version property of the object as set in the Gruntfile's `pkg` property. So if the version property of `grunt.config('pkg')` is `"0.1.2"`, has the content `Testing` and the `123` file had the content `1 2 3`, the generated result would be `Testing, 1 2 3.`

```js
grunt.initConfig({
  version: {
    // options: {},
    defaults: {
      src: ['src/testing.js', 'src/123.js']
    }
  }
})
```

#### Custom Options
In this example, custom options are used.

```js
grunt.initConfig({
  version: {
    options: {
      pkg: grunt.file.readJSON('myplugin.jquery.json')
    },
    myplugin: {
      options: {
        prefix: 'var version\\s+=\\s+[\'"]'
      },
      src: ['src/testing.js', 'src/123.js']
    },
    myplugin_patch: {
      options: {
        release: 'patch'
      },
      src: ['myplugin.jquery.json', 'src/testing.js', 'src/123.js'],
    }
  }
});
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt][].

## Release History
_(Nothing yet)_
