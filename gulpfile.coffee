gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
eco        = require 'gulp-eco'
plumber    = require 'gulp-plumber'
sourcemaps = require 'gulp-sourcemaps'
webserver  = require 'gulp-webserver'

gulp.task 'coffee:compile', ->
  environment = process.env.NODE_ENV ? 'development'
  configFile = "./config/#{environment}.coffee"

  files = [
    './app/models/*.coffee'
    './app/collections/*.coffee'
    './app/views/*.coffee'
    './app/router.coffee'
    configFile
  ]

  gulp.src files
      .pipe plumber()
      .pipe coffee()
      .pipe concat('application.js')
      .pipe sourcemaps.write('.')
      .pipe gulp.dest('./public/dist/')

gulp.task 'eco:compile', ->
  gulp.src ['./app/templates/*.eco']
      .pipe plumber()
      .pipe eco()
      .pipe concat('templates.js')
      .pipe sourcemaps.write('.')
      .pipe gulp.dest('./public/dist/')

gulp.task 'webserver', ->
  gulp.src './public'
      .pipe webserver({
        host: '0.0.0.0'
        port: 8888
        livereload: false
        directoryListing: false
        open: false
        fallback: 'index.html'
      })

gulp.task 'default', ['coffee:compile', 'eco:compile'], ->

gulp.task 'watch', ['default', 'webserver'], ->
  gulp.watch ['./app/**/*.coffee','./config/**/*.coffee'], ['coffee:compile']
  gulp.watch ['./app/**/*.eco'], ['eco:compile']
