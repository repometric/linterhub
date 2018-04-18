var fs = require('fs');
var del = require('del');
var gulp = require('gulp');

// Common pathes
var path = {
  docs: './docs/**/*.*',
  engine: './engine/*.json',
  schema: './schema/*.json',
  dest: './build'
};

// Clean output
gulp.task('clean', function () {
  return del([
    path.dest + '/**/*',
  ]);
});

// Copy static files
gulp.task('static', function () {
  return gulp
    .src([path.docs], {base: 'docs'})
    .pipe(gulp.dest(path.dest));
});

// Copy static files
gulp.task('engine', function () {
return gulp
    .src([path.engine], {base: 'engine'})
    .pipe(gulp.dest(path.dest + '/engine'));
});

// Copy static files
gulp.task('schema', function () {
    return gulp
        .src([path.schema], {base: 'schema'})
        .pipe(gulp.dest(path.dest + '/schema'));
    });

// The default task (called when you run `gulp` from cli)
gulp.task('default',  [
  'static',
  'engine',
  'schema',
]);
