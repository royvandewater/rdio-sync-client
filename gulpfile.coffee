gulp       = require 'gulp'
concat     = require 'gulp-concat'
cjsx       = require 'gulp-cjsx'
plumber    = require 'gulp-plumber'
sourcemaps = require 'gulp-sourcemaps'
webserver  = require 'gulp-webserver'

gulp.task 'cjsx:compile', ->
  environment = process.env.NODE_ENV ? 'development'
  configFile = "./config/#{environment}.cjsx"

  files = [
    configFile
    'config/config.cjsx'
    './app/models/*.cjsx'
    './app/collections/*.cjsx'
    './app/templates/*.cjsx'
    './app/views/*.cjsx'
    './app/router.cjsx'
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

gulp.task 'default', ['cjsx:compile'], ->

gulp.task 'watch', ['default', 'webserver'], ->
  gulp.watch ['./app/**/*.cjsx', './config/**/*.cjsx'], ['cjsx:compile']
