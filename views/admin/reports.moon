import Widget from require "lapis.html"
import Resources, ResourceReports from require "models"

breadcrumb = class extends Widget
	content: =>
		li class: "active", "Reports"

main = class MTAAdminReports extends Widget
	@include require "widgets.utils"

	category: "Reports"
	content: =>
		reports = ResourceReports\select "group by resource order by count desc", fields: "resource, count(resource)"
		ResourceReports\preload_relation reports, "resource", {as: "resource", fields: "resources.id, resources.name, resources.slug"}

		if #reports == 0
			p "Yay! All resource reports have been dealt with!"
			return

		element "table", class: "table table-hover table-striped table-sm", ->
			thead ->
				tr ->
					th "#"
					th "resource"
					th "count"
			tbody ->
				for report in *reports
					tr ->
						th scope: "row", report.resource.id
						td ->
							a href: (@url_for "resources.view", resource_slug: report.resource.slug), report.resource.name
						td ->
							em report.count
							form method: "POST", class: "mta-inline-form pull-xs-right", ->
								@write_csrf_input!
								input type: "hidden", name: "resource_id", value: report.resource.id
								button type: "submit", class: "btn btn-secondary btn-sm", -> i class: "fa fa-remove"

{:breadcrumb, :main}