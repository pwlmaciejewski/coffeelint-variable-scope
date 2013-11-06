module.exports = (grunt) ->
    grunt.initConfig
        coffee:
            index:
                files:
                    'index.js': 'index.coffee'

        watch:
            public:
                files: ['index.coffee']
                tasks: 'coffee' 

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'