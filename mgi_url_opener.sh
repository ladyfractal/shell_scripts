#/bin/sh
#Script name
#Adrienne J Davis
#Date
#Revision
#Useage


#Prompt for Account ID and then Application ID

printf "%s\n\n" "Please enter the account ID # and hit [Enter]."

read account_id

printf "%s\n\n" "Please enter the Application ID and hit [Enter]."

read application_id



#Sets URL to open the metric rules in use on account
metric_rules_url="https://rpm.newrelic.com/accounts/$account_id/url_rules"

#Sets URL to open the Metric Grouping page for account
metric_grouping_url="https://rpm.newrelic.com/admin/metric_explosion/show/$account_id"

#Sets URL to open the Insights for Resolvatron page
insights_url="https://staging-insights.newrelic.com/accounts/190/dashboards/132/filter=$account_id"

#Sets URL to open the Resolvatron page
resolvatron_url="http://use1v-dev-mgi-1.awsdev.nr-ops.net:3000/#/accounts/$account_id/applications"

#Sets URL to open the Environment page
environment_url="https://rpm.newrelic.com/accounts/$account_id/applications/$application_id/environment"

#Sets URL to open the Explore Metrics 
metric_explorer_url="https://rpm.newrelic.com/accounts/$account_id/agents/$application_id/metrics/explore_metrics?tw[end]=1402956988&tw[start]=1402956808#^
"

#Opens the URLs defined above in sequence

open $metric_rules_url

open $metric_grouping_url

open $insights_url

open $environment_url

open $metric_explorer_url






