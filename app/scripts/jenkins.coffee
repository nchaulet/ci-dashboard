'use strict'

angular
.module( 'JenkinsModule', [] )
.factory 'Jenkins', ($http) ->

	instance =

        getJobs: (callback) ->
            $http
            .jsonp('https://builds.apache.org/api/json/?jsonp=JSON_CALLBACK')
            .success (data) ->
            	callback(data.jobs)

        getJob : (url, callback) ->
         	$http.jsonp(url + '/api/json/?jsonp=JSON_CALLBACK')
          	.success (data) ->
                callback(data)

        getBuild : (url, callback) ->
         	$http.jsonp(url + '/api/json/?jsonp=JSON_CALLBACK' )
          	.success (data) ->
            	callback(data)


