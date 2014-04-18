require_relative './mongo'


module Issues_Aggregation

	def self.controller

		Mongo_Connection.mongo_Connect("localhost", 27017, "GitHub-Analytics", "Issues-Data")

	end

	def self.get_issues_opened_per_user(repo, githubAuthInfo)
		totalIssueSpentHoursBreakdown = Mongo_Connection.aggregate_test([
			{ "$match" => { downloaded_by_username: githubAuthInfo[:username], downloaded_by_userID: githubAuthInfo[:userID] }},
			{"$project" => {number: 1, 
							_id: 1, 
							repo: 1,  
							user: { login: 1}}},			
			{ "$match" => { repo: repo }},
			{ "$group" => { _id: {
							repo: "$repo",
							user: "$user.login",},
							issues_opened_count: { "$sum" => 1 }
							}}])
		output = []
		totalIssueSpentHoursBreakdown.each do |x|
			x["_id"]["issues_opened_count"] = x["issues_opened_count"]
			# x["_id"]["time_comment_count"] = x["time_comment_count"]
			output << x["_id"]
		end
		return output
	end

	# def self.get_issue_time(repo, issueNumber, githubAuthInfo)
	# 	totalIssueSpentHoursBreakdown = Mongo_Connection.aggregate_test([
	# 		{ "$match" => { downloaded_by_username: githubAuthInfo[:username], downloaded_by_userID: githubAuthInfo[:userID] }},
	# 		{"$project" => {type: 1, 
	# 						issue_number: 1, 
	# 						_id: 1, 
	# 						repo: 1,
	# 						milestone_number: 1, 
	# 						issue_state: 1, 
	# 						issue_title: 1, 
	# 						time_tracking_commits:{ duration: 1, 
	# 												type: 1, 
	# 												comment_id: 1 }}},
	# 		{ "$match" => { repo: repo }},			
	# 		{ "$match" => { type: "Issue" }},
	# 		{ "$match" => {issue_number: issueNumber.to_i}},
	# 		{ "$unwind" => "$time_tracking_commits" },
	# 		{ "$match" => { "time_tracking_commits.type" => { "$in" => ["Issue Time"] }}},
	# 		{ "$group" => { _id: {
	# 						repo_name: "$repo",
	# 						milestone_number: "$milestone_number",
	# 						issue_number: "$issue_number",
	# 						issue_title: "$issue_title",
	# 						issue_state: "$issue_state", },
	# 						time_duration_sum: { "$sum" => "$time_tracking_commits.duration" },
	# 						time_comment_count: { "$sum" => 1 }
	# 						}}
	# 						])
	# 	output = []
	# 	totalIssueSpentHoursBreakdown.each do |x|
	# 		x["_id"]["time_duration_sum"] = x["time_duration_sum"]
	# 		x["_id"]["time_comment_count"] = x["time_comment_count"]
	# 		output << x["_id"]
	# 	end
	# 	return output
	# end




	# # old name: analyze_issue_budget_hours
	# def self.get_all_issues_budget(repo, githubAuthInfo)
	# 	totalIssueSpentHoursBreakdown = Mongo_Connection.aggregate_test([
	# 		{ "$match" => { downloaded_by_username: githubAuthInfo[:username], downloaded_by_userID: githubAuthInfo[:userID] }},
	# 		{"$project" => {type: 1, 
	# 						issue_number: 1, 
	# 						_id: 1, 
	# 						repo: 1,
	# 						milestone_number: 1, 
	# 						issue_state: 1, 
	# 						issue_title: 1, 
	# 						time_tracking_commits:{ duration: 1, 
	# 												type: 1, 
	# 												comment_id: 1 }}},
	# 		{ "$match" => { repo: repo }},
	# 		{ "$match" => { type: "Issue" }},
	# 		{ "$unwind" => "$time_tracking_commits" },
	# 		{ "$match" => { "time_tracking_commits.type" => { "$in" => ["Issue Budget"] }}},
	# 		{ "$group" => { _id: {
	# 						repo_name: "$repo",
	# 						milestone_number: "$milestone_number",
	# 						issue_number: "$issue_number",
	# 						issue_state: "$issue_state",
	# 						issue_title: "$issue_title",},
	# 						budget_duration_sum: { "$sum" => "$time_tracking_commits.duration" },
	# 						budget_comment_count: { "$sum" => 1 }
	# 						}}
	# 						])
	# 	output = []
	# 	totalIssueSpentHoursBreakdown.each do |x|
	# 		x["_id"]["budget_duration_sum"] = x["budget_duration_sum"]
	# 		x["_id"]["budget_comment_count"] = x["budget_comment_count"]
	# 		output << x["_id"]
	# 	end
	# 	return output
	# end


	# def self.get_issue_budget(repo, issueNumber, githubAuthInfo)
	# 	totalIssueSpentHoursBreakdown = Mongo_Connection.aggregate_test([
	# 		{ "$match" => { downloaded_by_username: githubAuthInfo[:username], downloaded_by_userID: githubAuthInfo[:userID] }},
	# 		{"$project" => {type: 1, 
	# 						issue_number: 1, 
	# 						_id: 1, 
	# 						repo: 1,
	# 						milestone_number: 1, 
	# 						issue_state: 1, 
	# 						issue_title: 1, 
	# 						time_tracking_commits:{ duration: 1, 
	# 												type: 1, 
	# 												comment_id: 1 }}},			
	# 		{ "$match" => { repo: repo }},			
	# 		{ "$match" => { type: "Issue" }},
	# 		{ "$match" => {issue_number: issueNumber.to_i}},
	# 		{ "$unwind" => "$time_tracking_commits" },
	# 		{ "$match" => { "time_tracking_commits.type" => { "$in" => ["Issue Budget"] }}},
	# 		{ "$group" => { _id: {
	# 						repo_name: "$repo",
	# 						milestone_number: "$milestone_number",
	# 						issue_number: "$issue_number",
	# 						issue_state: "$issue_state",
	# 						issue_title: "$issue_title",},
	# 						budget_duration_sum: { "$sum" => "$time_tracking_commits.duration" },
	# 						budget_comment_count: { "$sum" => 1 }
	# 						}}
	# 						])
	# 	output = []
	# 	totalIssueSpentHoursBreakdown.each do |x|
	# 		x["_id"]["budget_duration_sum"] = x["budget_duration_sum"]
	# 		x["_id"]["budget_comment_count"] = x["budget_comment_count"]
	# 		output << x["_id"]
	# 	end
	# 	return output
	# end




	# def self.get_all_issues_time_in_milestone(repo, milestoneNumber, githubAuthInfo)
	# 	totalIssueSpentHoursBreakdown = Mongo_Connection.aggregate_test([
	# 		{ "$match" => { downloaded_by_username: githubAuthInfo[:username], downloaded_by_userID: githubAuthInfo[:userID] }},
	# 		{"$project" => {type: 1, 
	# 						issue_number: 1, 
	# 						_id: 1, 
	# 						repo: 1,
	# 						milestone_number: 1, 
	# 						issue_state: 1, 
	# 						issue_title: 1, 
	# 						time_tracking_commits:{ duration: 1, 
	# 												type: 1, 
	# 												comment_id: 1 }}},			
	# 		{ "$match" => { repo: repo }},			
	# 		{ "$match" => { type: "Issue" }},
	# 		{ "$match" => { milestone_number: milestoneNumber.to_i }},
	# 		{ "$unwind" => "$time_tracking_commits" },
	# 		{ "$match" => { "time_tracking_commits.type" => { "$in" => ["Issue Time"] }}},
	# 		{ "$group" => { _id: {
	# 						repo_name: "$repo",
	# 						milestone_number: "$milestone_number",
	# 						issue_number: "$issue_number",
	# 						issue_title: "$issue_title",
	# 						issue_state: "$issue_state", },
	# 						time_duration_sum: { "$sum" => "$time_tracking_commits.duration" },
	# 						time_comment_count: { "$sum" => 1 }
	# 						}}
	# 						])
	# 	output = []
	# 	totalIssueSpentHoursBreakdown.each do |x|
	# 		x["_id"]["time_duration_sum"] = x["time_duration_sum"]
	# 		x["_id"]["time_comment_count"] = x["time_comment_count"]
	# 		output << x["_id"]
	# 	end
	# 	return output
	# end



	# def self.get_total_issues_time_for_milestone(repo, milestoneNumber, githubAuthInfo)
	# 	totalIssueSpentHoursBreakdown = Mongo_Connection.aggregate_test([
	# 		{ "$match" => { downloaded_by_username: githubAuthInfo[:username], downloaded_by_userID: githubAuthInfo[:userID] }},
	# 		{"$project" => {type: 1, 
	# 						issue_number: 1, 
	# 						_id: 1, 
	# 						repo: 1,
	# 						milestone_number: 1, 
	# 						issue_state: 1, 
	# 						issue_title: 1, 
	# 						time_tracking_commits:{ duration: 1, 
	# 												type: 1, 
	# 												comment_id: 1 }}},			
	# 		{ "$match" => { repo: repo }},			
	# 		{ "$match" => { type: "Issue" }},
	# 		{ "$match" => { milestone_number: milestoneNumber.to_i }},
	# 		{ "$unwind" => "$time_tracking_commits" },
	# 		{ "$match" => { "time_tracking_commits.type" => { "$in" => ["Issue Time"] }}},
	# 		{ "$group" => { _id: {
	# 						repo_name: "$repo",
	# 						milestone_number: "$milestone_number"},
	# 						time_duration_sum: { "$sum" => "$time_tracking_commits.duration" },
	# 						time_comment_count: { "$sum" => 1 }
	# 						}}
	# 						])
	# 	output = []
	# 	totalIssueSpentHoursBreakdown.each do |x|
	# 		x["_id"]["time_duration_sum"] = x["time_duration_sum"]
	# 		x["_id"]["time_comment_count"] = x["time_comment_count"]
	# 		output << x["_id"]
	# 	end
	# 	return output
	# end





	# def self.get_all_issues_budget_in_milestone(repo, milestoneNumber, githubAuthInfo)
	# 	totalIssueSpentHoursBreakdown = Mongo_Connection.aggregate_test([
	# 		{ "$match" => { downloaded_by_username: githubAuthInfo[:username], downloaded_by_userID: githubAuthInfo[:userID] }},
	# 		{"$project" => {type: 1, 
	# 						issue_number: 1, 
	# 						_id: 1, 
	# 						repo: 1,
	# 						milestone_number: 1, 
	# 						issue_state: 1, 
	# 						issue_title: 1, 
	# 						time_tracking_commits:{ duration: 1, 
	# 												type: 1, 
	# 												comment_id: 1 }}},			
	# 		{ "$match" => { repo: repo }},
	# 		{ "$match" => { type: "Issue" }},
	# 		{ "$match" => { milestone_number: milestoneNumber.to_i }},
	# 		{ "$unwind" => "$time_tracking_commits" },
	# 		{ "$match" => { "time_tracking_commits.type" => { "$in" => ["Issue Budget"] }}},
	# 		{ "$group" => { _id: {
	# 						repo_name: "$repo",
	# 						milestone_number: "$milestone_number",
	# 						issue_number: "$issue_number",
	# 						issue_state: "$issue_state",
	# 						issue_title: "$issue_title",},
	# 						budget_duration_sum: { "$sum" => "$time_tracking_commits.duration" },
	# 						budget_comment_count: { "$sum" => 1 }
	# 						}}
	# 						])
	# 	output = []
	# 	totalIssueSpentHoursBreakdown.each do |x|
	# 		x["_id"]["budget_duration_sum"] = x["budget_duration_sum"]
	# 		x["_id"]["budget_comment_count"] = x["budget_comment_count"]
	# 		output << x["_id"]
	# 	end
	# 	return output
	# end


	# # Get repo sum of issue time
	# def self.get_repo_time_from_issues(repo, githubAuthInfo)
	# 	totalIssueSpentHoursBreakdown = Mongo_Connection.aggregate_test([
	# 		{ "$match" => { downloaded_by_username: githubAuthInfo[:username], downloaded_by_userID: githubAuthInfo[:userID] }},
	# 		{"$project" => {type: 1, 
	# 						issue_number: 1, 
	# 						_id: 1, 
	# 						repo: 1,
	# 						milestone_number: 1, 
	# 						issue_state: 1, 
	# 						issue_title: 1, 
	# 						time_tracking_commits:{ duration: 1, 
	# 												type: 1, 
	# 												comment_id: 1 }}},			
	# 		{ "$match" => { repo: repo }},
	# 		{ "$match" => { type: "Issue" }},
	# 		{ "$unwind" => "$time_tracking_commits" },
	# 		{ "$match" => { "time_tracking_commits.type" => { "$in" => ["Issue Time"] }}},
	# 		{ "$group" => { _id: {
	# 						repo_name: "$repo"},
	# 						time_duration_sum: { "$sum" => "$time_tracking_commits.duration" },
	# 						time_comment_count: { "$sum" => 1 }
	# 						}}
	# 						])
	# 	output = []
	# 	totalIssueSpentHoursBreakdown.each do |x|
	# 		x["_id"]["time_duration_sum"] = x["time_duration_sum"]
	# 		x["_id"]["time_comment_count"] = x["time_comment_count"]
	# 		output << x["_id"]
	# 	end
	# 	return output
	# end

	# # Sums all issue budgets for the repo and outputs the total budget based on issues
	# def self.get_repo_budget_from_issues(repo, githubAuthInfo)
	# 	totalIssueSpentHoursBreakdown = Mongo_Connection.aggregate_test([
	# 		{ "$match" => { downloaded_by_username: githubAuthInfo[:username], downloaded_by_userID: githubAuthInfo[:userID] }},
	# 		{"$project" => {type: 1, 
	# 						issue_number: 1, 
	# 						_id: 1, 
	# 						repo: 1,
	# 						milestone_number: 1, 
	# 						issue_state: 1, 
	# 						issue_title: 1, 
	# 						time_tracking_commits:{ duration: 1, 
	# 												type: 1, 
	# 												comment_id: 1 }}},			
	# 		{ "$match" => { repo: repo }},
	# 		{ "$match" => { type: "Issue" }},
	# 		{ "$unwind" => "$time_tracking_commits" },
	# 		{ "$match" => { "time_tracking_commits.type" => { "$in" => ["Issue Budget"] }}},
	# 		{ "$group" => { _id: {
	# 						repo_name: "$repo"},
	# 						budget_duration_sum: { "$sum" => "$time_tracking_commits.duration" },
	# 						budget_comment_count: { "$sum" => 1 }
	# 						}}
	# 						])
	# 	output = []
	# 	totalIssueSpentHoursBreakdown.each do |x|
	# 		x["_id"]["budget_duration_sum"] = x["budget_duration_sum"]
	# 		x["_id"]["budget_comment_count"] = x["budget_comment_count"]
	# 		output << x["_id"]
	# 	end
	# 	return output
	# end
end


# Debug code
# Issues_Aggregation.controller
# puts Issues_Aggregation.get_issues_opened_per_user("StephenOTT/Test1", {:username => "StephenOTT", :userID => 1994838})



