path = require "path"

module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    coffee:
      compile:
        expand: true,
        flatten: false,
        cwd: 'src/coffee/',
        src: ['**/*.coffee'],
        dest: 'dist/js/',
        ext: '.js'
        options:
          # Don't wrap CoffeeScript files in IFFE's by default.
          # We don't need them since we're using requirejs and everything
          # is wrapped in a `define`, and it breaks the r.js build
          # when we run `grunt requirejs`. Any files not using `define` though
          # should wrap the CoffeeScript in an IFFE manually with a `do ->`
          bare: true

    compass:
      dev:
        options:
          sassDir: 'src/sass'
          cssDir: 'dist/css'

    watch:
      scripts:
        files: ['src/**/*.coffee']
        tasks: ['coffee']
      styles:
        files: ['src/**/*.scss']
        tasks: ['compass']

    express:
      debug: true
      port: 8000
      server: "server/server.coffee"


  grunt.loadNpmTasks('grunt-contrib/node_modules/grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib/node_modules/grunt-contrib-compass')
  grunt.loadNpmTasks('grunt-contrib/node_modules/grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib/node_modules/grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-express')

  grunt.registerTask('setup', ['coffee', 'compass'])
  grunt.registerTask('default', ['setup', 'watch'])
  grunt.registerTask('server', ['express', 'express-keepalive'])
