// 'use strict';



// angular.module('jenkinsApp')
//   .controller('DashCtrl', function ($scope, $http, Jenkins, $routeParams, Dashboard) {

//     $scope.dash = Dashboard.getDashboard($routeParams.name);

//     console.log($scope.dash);
//     var test = $scope.dash);
//     console.log(test);
//      var test = model.Dashboard.fromJSON(test);
//      console.log(test);
//     // Jenkins.getJobs(function(jo
//         // bs) {
//     //     $scope.availableJobs = jobs;
//     // });

//     // $scope.jobs = $scope.dash.jobs;

//     // for(var i in $scope.jobs) {
//     //     var job = $scope.jobs[i];

//     //     job = Jenkins.getJob(job.url, function(data) {

//     //         console.log(data);
//     //         job.order = i;
//     //         job.info = data;

//     //         Jenkins.getBuild(job.info.lastBuild.url, function(data) {

//     //             console.log(data);
//     //             job.build = data;
//     //         });
//     //     });
//     // }

//     $scope.addJenkinsJobs = function() {

//         Dashboard.addJenkinsJob($scope.selectedJob);

//         Jenkins.getJob($scope.selectedJob, function(job) {
//             $scope.jobs.push(job);
//         });
//     };

//     $scope.saveDashboard = function() {

//         Dashboard.saveDashboard($scope.dash.name, $scope.jobs);
//     };

//   });


