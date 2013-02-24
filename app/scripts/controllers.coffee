# dashboard home page
angular.module('dashboardApp')
 .controller 'MainCtrl',  ($scope, DashboardManager) ->

    $scope.dashboards = DashboardManager.getDashboards()

    $scope.newDash =  () ->
        DashboardManager.createDashboard($scope.newName)
        $scope.newName = null

# dashboard controller
angular.module('dashboardApp')
 .controller 'DashCtrl',  ($scope, $routeParams, DashboardManager, Jenkins) ->

 	$scope.dashboard = DashboardManager.getDashboard($routeParams.name)

 	for item in $scope.dashboard.items
 		item.load Jenkins


# Dashboard parameters controller
angular.module('dashboardApp')
 .controller 'DashParamsCtl',  ($scope, Jenkins, DashboardManager) ->

 	Jenkins.getJobs (jobs) ->
 		$scope.jenkinsJobs = jobs;

 	$scope.addJenkinsJob =  (job) ->
 		job = JSON.parse(job)
 		DashboardManager.addJenkinsJob(job.name, job.url)

 	$scope.saveDashboard = () ->
 		DashboardManager.saveCurrentDashboard()




