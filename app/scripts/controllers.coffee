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
 	DashboardManager.loadDashboard()

 	$scope.timer = setInterval () =>
 		DashboardManager.loadDashboard()
 	, $scope.dashboard.refreshInterval

 	$scope.$on '$destroy', (event) =>
 		clearInterval($scope.timer)


# Dashboard parameters controller
angular.module('dashboardApp')
 .controller 'DashParamsCtl',  ($scope, $routeParams, Jenkins, DashboardManager) ->

 	$scope.dashboard = DashboardManager.currentDashboard

 	Jenkins.getJobs (jobs) ->
 		$scope.jenkinsJobs = jobs;

 	$scope.addJenkinsJob =  (job) ->
 		console.log job
 		job = JSON.parse(job)
 		DashboardManager.addJenkinsJob(job.name, job.url)

 	$scope.saveDashboard = () ->
 		DashboardManager.saveCurrentDashboard()




