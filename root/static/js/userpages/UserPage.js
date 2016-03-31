app.controller('UserPageController', function($scope, $http, fn) {
    $scope.fn = fn;

    $http.get(window.location.pathname + "/index.json").success(function(response) {
	$scope.data = response;
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
    $scope.showUser = function() {
	$scope.count = {};
	$scope.topics = [];

	// developed & maintained IAs, all in one array
	$scope.ias = _.filter(ias, function(ia) {
	    return (_.some(ia.developer, function(d) { return d.name == $scope.username}) || (ia.maintainer && ia.maintainer.github == $scope.username));
	});

	// developed IAs -- using http://underscorejs.org/
	$scope.ias_developed = _.filter(ias, function(ia) {
	    return _.some(ia.developer, function(d) { return d.name == $scope.username});
	});

	// maintained IAs (no ghosted or deprecated)
	$scope.ias_maintained = _.filter(ias, function(ia) {
	    return (ia.maintainer && ia.maintainer.github == $scope.username) && !(ia.dev_milestone=='ghosted' || ia.dev_milestone=='deprecated');
	});

	// developed IAs but NOT maintained (no ghosted or deprecated)
	$scope.ias_developed_only = _.filter(ias, function(ia) {
	    return (_.some(ia.developer, function(d) { return d.name == $scope.username}) && !(ia.maintainer && ia.maintainer.github == $scope.username) && !(ia.dev_milestone=='ghosted' || ia.dev_milestone=='deprecated'));
	});

	// opened issues
	$scope.issues_open = _.filter($scope.user.issues, function(issue) {
	    return issue.state === 'open' && issue.body.match(/https:\/\/duck\.co\/ia\/view\/(.*?)/);
	});

	// all pull requests (from issues list)
	$scope.prs = _.filter($scope.user.issues, function(issue) {
	    return issue.pull_request != null;
	});

	// opened pull requests
	$scope.prs_open = _.filter($scope.prs, function(pr) {
	    return pr.state == 'open';
	});

	// opened pull requests & being reviewed by user
	$scope.prs_open_reviewed = _.filter($scope.prs, function(pr) {
	    return (pr.state == 'open' && (pr.assignee && pr.assignee.login == $scope.username));
	});

	var getIA = function(issue) {
	    var ia = issue.body.match(/https:\/\/duck\.co\/ia\/view\/([_a-zA-Z]+)/);

	    if(ia) {
		return _.extend(issue, { ia_page: ia[1].replace(/_/g, " ").replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}) });
	    }

	    return issue;
	};

	$scope.prs_open_reviewed_2 = _.map(_.filter($scope.prs, function(pr) {
	    return /https:\/\/duck\.co\/ia\/view\//.test(pr.body) && (pr.state == 'open' && (pr.assignee && pr.assignee.login == $scope.username));
	}), getIA);

	// opened pull requests & developed by user
	$scope.prs_open_developed = _.filter($scope.prs, function(pr) {
	    return (pr.state == 'open' && (pr.user && pr.user.login == $scope.username));
	});

	// opened pull requests & developed by user
	$scope.prs_open_developed_2 = _.map(_.filter($scope.prs, function(pr) {
	    return /https:\/\/duck\.co\/ia\/view\//.test(pr.body) && (pr.state == 'open' && (pr.user && pr.user.login == $scope.username));
	}), getIA);

	// topic list
	var topics = {};
	_.each($scope.ias, function(ia) {
	    if (ia.topic) {
		_.each(ia.topic, function(t) {
		    if (topics[t]) ++topics[t];
		    else topics[t] = 1;
		});
	    }
	});

	_.each(topics, function(value, key) {
	    var obj = {topic: '', amount: 0}
	    obj.topic = key;
	    obj.amount = value;
	    $scope.topics.push(obj);
	});

	$scope.count.all_ias = _.size($scope.ias);
	$scope.count.maintained_ias = _.size($scope.ias_maintained);
	$scope.count.developed_only_ias = _.size($scope.ias_developed_only);
	$scope.count.open_issues = _.size($scope.issues_open);
	$scope.count.closed_issues = _.size($scope.user.issues) - $scope.count.open_issues;
	$scope.count.open_prs = _.size($scope.prs_open);
	$scope.count.reviewed_prs = _.size($scope.prs_open_reviewed);
	$scope.count.developed_prs = _.size($scope.prs_open_developed);
	$scope.count.closed_prs = _.size($scope.prs) - $scope.count.open_prs;

	var maxtopic = _.max($scope.topics, function(topic){ return topic.amount; });
	$scope.count.max_topics = maxtopic.amount;

	// by default. for 'filterable'
	$scope.show_ias = ($scope.count.maintained_ias) ? $scope.ias_maintained : $scope.ias_developed_only;

    }

    // initializing a default user
    $scope.showUser();

    // initializing show_issues
    $scope.show_issues = '';

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
	// get avatar image. If not found, uses first letter from devname
	getAvatar: function(users, username, align) {
	    var html = '';
	    if (username) {
		html = '<div class="avatar ' + align + '" title="' + username + '"';
		var user = this.findByAttr(users, 'username', username);

		if (user && user.avatar) html += '><img src="avatars/' + user.avatar + '" /></div>';
		else html += "><span>" + username.charAt(0) + '</span></div>';
	    }

	    return html;
	},
	// get developers based on an instant answer; returns html
	getDevs: function(ia) {
	    var html = '';
	    _.each(ia.developer, function(dev) {
		html += '<span>' + dev.name + ' </span>';
	    });
	    return html;
	},
	// get developers based on an instant answer; returns avatars
	getDevsAvatars: function(ia, users, skipname) {
	    var html = '';
	    _.each(ia.developer, function(dev) {
		// console.log(skipname + ' | ' + dev.name);
		if (skipname != dev.name) html += this.getAvatar(users, dev.name, '');
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

    };
});
