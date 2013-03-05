# dashboard home page
angular.module('dashboardApp')
 .controller 'MainCtrl',  ($scope, DashboardManager) ->

    $scope.exampleData = () ->
        DashboardManager.createDashboard('exampleDash')
        DashboardManager.getDashboard('exampleDash')
        DashboardManager.addTravisJob('willdurand/Geocoder')
        DashboardManager.addTravisJob('symfony/symfony')
        DashboardManager.addTravisJob('fabpot/Twig')
        DashboardManager.saveCurrentDashboard()


    $scope.dashboards = DashboardManager.getDashboards()

    if $scope.dashboards.length == 0
        $scope.exampleData()


    $scope.newDash =  () ->
        DashboardManager.createDashboard($scope.newName)
        $scope.newName = null