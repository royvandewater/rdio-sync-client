gulp       = require 'gulp'
concat     = require 'gulp-concat'
cjsx       = require 'gulp-cjsx'
plumber    = require 'gulp-plumber'
sourcemaps = require 'gulp-sourcemaps'
webserver  = require 'gulp-webserver'

gulp.task 'coffee:compile', ->
  environment = process.env.NODE_ENV ? 'development'
  configFile = "./config/#{environment}.coffee"

  files = [
    configFile
    'config/config.coffee'
    './app/models/*.coffee'
    './app/collections/*.coffee'
    './app/templates/*.cjsx'
    './app/views/*.coffee'
    './app/router.coffee'
  ]

  gulp.src files
      .pipe plumber()
      .pipe sourcemaps.init()
      .pipe cjsx()
      .pipe concat('application.js')
      .pipe sourcemaps.write('.')
      .pipe gulp.dest('./public/dist/')

gulp.task 'webserver', ->
  gulp.src './public'
      .pipe webserver({
        host: '0.0.0.0'
        port: 3005
        livereload: false
        directoryListing: false
        open: false
        fallback: 'index.html'
      })

gulp.task 'default', ['coffee:compile'], ->

gulp.task 'watch', ['default', 'webserver'], ->
  gulp.watch ['./app/**/*.coffee', './app/templates/*.cjsx', './config/**/*.coffee'], ['coffee:compile']
