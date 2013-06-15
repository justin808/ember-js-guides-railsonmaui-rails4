#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require ./router
#= require_self
#= require ./fixtures

App.Store = DS.Store.extend(
  revision: 12
  adapter: "DS.RESTAdapter" # "DS.FixtureAdapter"
)

App.Post = DS.Model.extend(
  title: DS.attr("string")
  author: DS.attr("string")
  intro: DS.attr("string")
  extended: DS.attr("string")
  publishedAt: DS.attr("date")
)

App.PostsRoute = Ember.Route.extend(
  model: ->
    App.Post.find()
)

# See Discussion at http://stackoverflow.com/questions/14705124/creating-a-record-with-ember-js-ember-data-rails-and-handling-list-of-record
App.PostsController = Ember.ArrayController.extend(
  sortProperties: [ "id" ]
  sortAscending: false
  filteredContent: (->
    content = @get("arrangedContent")
    content.filter (item, index) ->
      not (item.get("isNew"))
  ).property("arrangedContent.@each")
)

App.PostsNewRoute = Ember.Route.extend(
  model: ->
    App.Post.createRecord(publishedAt: new Date(), author: "current user")
)

App.PostsNewController = Ember.ObjectController.extend(
  save: ->
    @get('store').commit()

  cancel: ->
    @get('content').deleteRecord()
    @get('store').transaction().rollback()
    @transitionToRoute('posts')

  transitionAfterSave: ( ->
    # when creating new records, it's necessary to wait for the record to be assigned
    # an id before we can transition to its route (which depends on its id)
    @transitionToRoute('post', @get('content')) if @get('content.id')
  ).observes('content.id')
)

App.PostController = Ember.ObjectController.extend(
  isEditing: false
  edit: ->
    @set "isEditing", true

  delete: ->
    if (window.confirm("Are you sure you want to delete this post?"))
      @get('content').deleteRecord()
      @get('store').commit()
      @transitionToRoute('posts')

  doneEditing: ->
    @set "isEditing", false
    @get('store').commit()

)
App.IndexRoute = Ember.Route.extend(redirect: ->
  @transitionTo "posts"
)
Ember.Handlebars.registerBoundHelper "date", (date) ->
  moment(date).fromNow()

window.showdown = new Showdown.converter()

Ember.Handlebars.registerBoundHelper "markdown", (input) ->
  new Ember.Handlebars.SafeString(window.showdown.makeHtml(input)) if input # need to check if input is defined and not null

App.Router.map ->
  @resource "about"
  @resource "posts", ->
    @resource "post",
      path: ":post_id"
    @route "new"
