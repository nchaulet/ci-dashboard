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

    $scope.selectItemAction = (item) ->
        $scope.selectedItem = item

    $scope.saveDashboardAction = () ->
        DashboardManager.saveCurrentDashboard()


# Dashboard parameters controller
angular.module('dashboardApp')
 .controller 'DashSettingsCtl',  ($scope, $routeParams, Jenkins, DashboardManager) ->

    $scope.dashboard = DashboardManager.currentDashboard


# Dashboard jenkins controller
angular.module('dashboardApp')
 .controller 'JenkinsCtl',  ($scope, $routeParams, Jenkins, DashboardManager) ->
    console.log 'test'
    $scope.dashboard = DashboardManager.currentDashboard

    $scope.searchJenkinsJobsAction = () ->
        Jenkins.getJobs $scope.jenkinsServer, (jobs) ->
            $scope.jenkinsJobs = jobs;

    $scope.addJenkinsJobAction =  (job) ->

            job = JSON.parse(job)
            DashboardManager.addJenkinsJob(job.name, job.url)
            $scope.dismiss()

# Travis  controller
angular.module('dashboardApp')
 .controller 'TravisCtl',  ($scope, $routeParams, Jenkins, DashboardManager) ->
    console.log 'test'
    $scope.dashboard = DashboardManager.currentDashboard

    $scope.addTravisJobAction = (name) ->
        DashboardManager.addTravisJob(name)
        $scope.dismiss()


angular.module('dashboardApp')
 .controller 'ItemEditCtl',  ($scope, Jenkins, DashboardManager) ->

    $scope.deleteItemAction = (item) ->
        # find more sexy
        if confirm('delete item ?')
            DashboardManager.removeItem(item)
            $scope.$parent.selectedItem = null





