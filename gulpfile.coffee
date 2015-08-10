gulp = require 'gulp'
jade = require 'gulp-jade'
util = require 'gulp-util'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'

buildPath = 'dist'
bowerPath = 'bower_components'

gulp.task 'coffee', ->
   gulp
      .src './coffee/*.coffee'
      .pipe coffee bare: true
      .pipe gulp.dest "#{buildPath}/js"


gulp.task 'copy-js', ->
   gulp
      .src [
         "#{bowerPath}/voila/voila.pkgd.min.js"
      ]
      .pipe gulp.dest "#{buildPath}/js"


gulp.task 'copy-img', ->
   gulp
      .src [
         './img/**/*'
      ]
      .pipe gulp.dest "#{buildPath}/img"


gulp.task 'sass', ->
   gulp
      .src './sass/*.sass'
      .pipe sass includePaths: "#{bowerPath}/modularized-normalize-scss"
      .pipe gulp.dest "#{buildPath}/css"


gulp.task 'jade', ->
   gulp
      .src './jade/*.jade'
      .pipe jade pretty: true
      .pipe gulp.dest "#{buildPath}"


gulp.task 'default', ->
   gulp.start 'coffee', 'copy-js', 'copy-img', 'sass', 'jade'

