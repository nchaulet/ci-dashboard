'use strict';

# Model class
class Dashboard

    constructor: (@name, refreshInterval) ->
        @items= []
        refreshInterval ?= 20000
        @refreshInterval = refreshInterval

    addItem: (item) ->
        @items.push(item)



class DashboardItem


    constructor: (@name, @type) ->



class DashboardItemJenkinsJob extends DashboardItem

    constructor: (name, @url) ->
       super name,'jenkins'

    load: (jenkins) ->

        jenkins.getJob @url, (info) =>
            @info = info

            jenkins.getBuild @info.lastBuild.url, (build) =>
                @build = build

# Object to serialize dashboards
DashboardSerializer =

    serialize: (dashboard) ->
        jsonObj =
            name: dashboard.name
            refreshInterval: dashboard.refreshInterval
            items: []

        for item in dashboard.items
            jsonObj.items.push(@serializeItem(item))

        JSON.stringify jsonObj

    serializeItem: (item) ->
        jsonObj =
            name : item.name
            type : item.type

        switch item.type
            when 'jenkins' then jsonObj = @serializeJenkinsItem(item, jsonObj)

        jsonObj

    serializeJenkinsItem: (item, jsonObj) ->
        jsonObj.url = item.url

        jsonObj



    deserialize:(json) ->
        if not json?
            return null

        jsonObj = JSON.parse json
        obj = new Dashboard(jsonObj.name, jsonObj.refreshInterval)

        for item in jsonObj.items
            obj.addItem @deserializeItem item

        obj

    deserializeItem: (item) ->
        obj = null
        switch item.type
            when 'jenkins' then obj = @deserializeJenkinsItem(item)

        obj

    deserializeJenkinsItem: (item) ->
        obj = new DashboardItemJenkinsJob(item.name, item.url)


angular.module('DashboardModule', [])
.factory 'DashboardManager', (localStorageService, Jenkins) ->


    instance =

        dashboards: null

        currentDashboard: null

        # return all Dashboards
        getDashboards: () ->
            @dashboards = JSON.parse(localStorageService.get('dashboards'));
            @dashboards ?= []

        # create a new dashboard
        createDashboard : (name) ->
            this.dashboards.push({name : name})
            localStorageService.add('dashboards', JSON.stringify(@dashboards))

        getDashboard :(name) ->
            @currentDashboard = DashboardSerializer.deserialize(localStorageService.get(name));

            if not @currentDashboard?
                @currentDashboard = new Dashboard(name)

            @currentDashboard

        loadDashboard:() ->
            console.log 'load dashboard'
            for item in @currentDashboard.items
                if item instanceof DashboardItemJenkinsJob
                    item.load(Jenkins)

        addJenkinsJob : (name, url) ->
            @currentDashboard.addItem(new DashboardItemJenkinsJob(name, url))


        saveCurrentDashboard : () ->
           # @currentDashboard.addItem( new DashboardItemJenkinsJob('job2' ,'http://test.fr'))
            localStorageService.add(@currentDashboard.name, DashboardSerializer.serialize(@currentDashboard))

# this.model.Dashboard = Dashboard