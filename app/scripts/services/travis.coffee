'use strict'

angular
.module( 'TravisCiModule', [] )
.factory 'TravisCi', ($http) ->

    delete $http.defaults.headers.common['X-Requested-With']

    instance =

        getRepo : (repo, callback) ->


            $http.get('https://api.travis-ci.org/repos/'+repo+'.json')
            .success (data) ->
                console.log data
                callback(data)



