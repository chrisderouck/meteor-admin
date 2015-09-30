Template.AdminDashboardViewWrapper.rendered = ->
	node = @firstNode

	@autorun ->
		data = Template.currentData()

		if data.view then Blaze.remove data.view
		while node.firstChild
			node.removeChild node.firstChild

		data.view = Blaze.renderWithData Template.AdminDashboardView, data, node

Template.AdminDashboardViewWrapper.destroyed = ->
	Blaze.remove @data.view

Template.AdminDashboardView.rendered = ->
	table = @$('.dataTable').DataTable();
	filter = @$('.dataTables_filter')
	length = @$('.dataTables_length')

	filter.html '
		<div class="input-group">
			<input type="search" class="form-control input-sm" placeholder="Search"></input>
			<div class="input-group-btn">
				<button class="btn btn-sm btn-default">
					<i class="fa fa-search"></i>
				</button>
			</div>
		</div>
	'

	length.html '
		<select class="form-control input-sm">
			<option value="10">10</option>
			<option value="25">25</option>
			<option value="50">50</option>
			<option value="100">100</option>
		</select>
	'

	filter.find('input').on 'keyup', ->
		table.search(@value).draw()

	length.find('select').on 'change', ->
		table.page.len(parseInt @value).draw()

Template.AdminDashboardView.helpers
	hasDocuments: ->
		AdminCollectionsCount.findOne({collection: Session.get 'admin_collection_name'})?.count > 0
	newPath: ->
		Router.path 'adminDashboard' + Session.get('admin_collection_name') + 'New'

Template.adminEditBtn.helpers
	path: ->
		Router.path "adminDashboard" + Session.get('admin_collection_name') + "Edit", _id: @_id

Template.adminTranslateBtn.helpers
	path: (language, id)->
		Router.path "adminDashboard" + Session.get('admin_collection_name') + "Translate" + language, _id: id
	languages: ->
		ori = TAPi18n.getLanguages()
		languages = Object.keys(ori).map (k) ->
			item = ori[k]
			item.code = k
			item
		languages

# Note, you would expect the template of the translate button, however this gets rendered in another template,
# thus this is the one we should target to attach events
Template.AdminDashboardViewWrapper.events
	"change select.translateButtons": (event, template) ->
		console.log('changed')
		translatePath = event.currentTarget.value
		console.log('path: ' + translatePath)
		Router.go(translatePath)