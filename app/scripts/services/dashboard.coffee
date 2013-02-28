'use strict';

# Model class
class Dashboard

    constructor: (@name, refreshInterval) ->
        @items= []
        refreshInterval ?= 20000
        @refreshInterval = refreshInterval

    addItem: (item) ->
        @items.push(item)

    removeItem: (item) ->
        @items.splice(@items.indexOf(item), 1)



class DashboardItem

    constructor: (@name, @type) ->



class DashboardItemJenkinsJob extends DashboardItem

    constructor: (name, @url) ->
       super name,'jenkins'

    load: (jenkins) ->

        jenkins.getJob @url, (info) =>
            @info = info
            @status = if info.color == 'blue' then 'success' else if info.color == 'red' then 'fail' else 'disabled'
            @url = info.url

            jenkins.getBuild @info.lastBuild.url, (build) =>
                @build = build
                @lastBuildDate = build.timestamp


class DashboardItemTravisCiJob extends DashboardItem

    constructor: (name) ->
       super name, 'travis'
       @url = 'https://travis-ci.org/'+name

    load: (travis) ->

        travis.getRepo (@name) , (data) =>
            @lastBuildDate = data.last_build_finished_at
            @status = if data.last_build_status == 0 then 'success' else 'fail'


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
            when 'travis'  then obj = @deserializeTravisItem(item)

        obj

    deserializeTravisItem: (item) ->
        obj = new DashboardItemTravisCiJob(item.name)

    deserializeJenkinsItem: (item) ->
        obj = new DashboardItemJenkinsJob(item.name, item.url)


angular.module('DashboardModule', [])
.factory 'DashboardManager', (localStorageService, Jenkins, TravisCi) ->


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
            for item in @currentDashboard.items
                if item instanceof DashboardItemJenkinsJob
                    item.load(Jenkins)
                if item instanceof DashboardItemTravisCiJob
                    item.load(TravisCi)

        addJenkinsJob : (name, url) ->
            @currentDashboard.addItem(new DashboardItemJenkinsJob(name, url))

        addTravisJob : (name) ->
            @currentDashboard.addItem(new DashboardItemTravisCiJob(name))

        removeItem: (item) ->
            @currentDashboard.removeItem(item)

        saveCurrentDashboard : () ->
           # @currentDashboard.addItem( new DashboardItemJenkinsJob('job2' ,'http://test.fr'))
            localStorageService.add(@currentDashboard.name, DashboardSerializer.serialize(@currentDashboard))

# this.model.Dashboard = Dashboard
