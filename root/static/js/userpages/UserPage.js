app.controller('UserPageController', function($scope, $http, fn) {
    $scope.fn = fn;

    $http.get(window.location.pathname + "/index.json").success(function(response) {
	$scope.showUser(response);
    });


    // for sorting instant answers (live should be first)
    $scope.iaSort = function(ia) {
	switch (ia.dev_milestone) {
	case 'live': return 0;
	case 'complete': return 10;
	case 'testing': return 20;
	case 'development': return 30;
	case 'planning': return 40;
	default: return 1000;
	}
    };

    var initial = false;

    // given a username, fill out the $scope variables appropriately, like IAs, etc.
    $scope.showUser = function(response) {
	$scope.response = response;
	$scope.count = {};
	$scope.topics = [];

    $scope.imgUrl = 'https://duckduckgo.com/t/userpage_' + $scope.response.gh_data.id;
    $scope.randomNum = Math.ceil(Math.random() * 1e7);
    $scope.imgUrlSuffix = '?' + Math.ceil(Math.random() * 1e7);

    $scope.appendToUrl = function(element_id) {
        $scope.randomNum = Math.ceil(Math.random() * 1e7);
        $scope.imgUrlSuffix = '_' + element_id + '?' + random;
	};

	$scope.ias = [];
	_.each(response.ia, function(element, index) {
	    $scope.ias = $scope.ias.concat(element);
	});

	$scope.ias_developed_only = _.filter($scope.ias, function(ia) {
	    console.log(ia);
	    return _.find(ia.developer, function(dev) {
		return (dev.name === response.gh_data.login || dev.name === response.gh_data.name) && dev.type === "github";
	    }) && ia.dev_milestone !== "ghosted";
	});

	$scope.prs_open = _.filter(response.pulls, function(pull) {
	    return pull.state === "open";
	});

	$scope.prs_open_developed = _.filter(response.pulls_created, function(pull) {
	    return pull.state === "open";
	});
	$scope.prs_open_reviewed = _.filter(response.pulls_assigned, function(pull) {
	    return pull.state === "open";
	});


	$scope.maintained = _.filter(response.maintained, function(ia) {
	    return ia.dev_milestone !== "ghosted";
	});

	$scope.count.maintained_ias = _.size($scope.maintained);
	$scope.count.developed_only_ias = _.size($scope.ias_developed_only);
	$scope.count.open_issues = _.size(response.issues);
	$scope.count.closed_issues = _.size(response.issues) - $scope.count.open_issues;
	$scope.count.open_prs = _.size($scope.prs_open);
	$scope.count.reviewed_prs = _.size(response.pulls_assigned);
	$scope.count.developed_prs = _.size($scope.prs_open_developed);
	$scope.count.closed_prs = response.closed_pulls;
	$scope.count.ias = _.size($scope.ias);

	$scope.ias_maintained = response.maintained;

	$scope.topics = _.map(response.topics, function(key, num) {
	    return {count: key, topic: num};
	});

	$scope.count.total_ias = (function() {
	    var all = {};
	    _.each($scope.maintained.concat($scope.ias_developed_only), function(ia) {
		all[ia.id] = true;
	    });

	    return _.size(all);
	}());

	var maxtopic = _.max($scope.topics, function(topic) { 
	    return topic.count; 
	});

	$scope.count.max_topics = maxtopic.count;

	// by default. for 'filterable'
	$scope.show_ias = ($scope.count.maintained_ias) ? $scope.maintained : $scope.ias_developed_only;
    }
});

// helper functions
app.factory('fn', function() {
    return {
	// given an array, search for an attr (like 'username'): if found, return object
	findByAttr: function(arr, attr, name) {
	    return _.find(arr, function(obj) {
		return obj[attr] == name;
	    });
	},
	
    getAvatar: function(dev) {
	    var html = '';
	    html = '<div class="avatar" title="' + dev.username + '"';

	    if (dev.avatar_url) html += '><a href="/' + dev.username.toLowerCase() + '"><img src="' + dev.avatar_url + '" /></a></div>';
	    else html += "><a href='/" + dev.username.toLowerCase() + "'><span>" + dev.username.charAt(0) + '</span></a></div>';

	    return html;
	},
	
    getDevs: function(ia) {
	    var html = '';
	    _.each(ia.developer, function(dev) {
		html += '<span>' + dev.name + ' </span>';
	    });
	    return html;
	},
	// get developers based on an instant answer; returns avatars
	getDevsAvatars: function(ia, skipname) {
	    var html = '';
	    _.each(ia.contributors, function(dev) {
		html += this.getAvatar(dev);
	    }, this);

	    return html;
	},
	// get topics based on an instant answer; returns html
	getTopics: function(ia) {
	    var html = '';
	    _.each(ia.topic, function(topic) {
		html += '<span>' + topic + ' </span>';
	    });
	    return html;
	},
	// get labels based on an issue; returns html
	getLabels: function(issue) {
	    var html = '';
	    _.each(issue.labels, function(label) {
		html += '<span>' + label.name + '; </span>';
	    });
	    return html;
	},
	// get "time ago" from date
	getFromNow: function(datetimestr) {
            return moment(datetimestr).fromNow();
    }
	// generate a random number

    };
});
