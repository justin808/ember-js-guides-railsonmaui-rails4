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
  revision: 11
  adapter: "DS.FixtureAdapter"
)

App.Post = DS.Model.extend(
  title: DS.attr("string")
  author: DS.attr("string")
  intro: DS.attr("string")
  extended: DS.attr("string")
  publishedAt: DS.attr("date")
)
App.PostsRoute = Ember.Route.extend(model: ->
  App.Post.find()
)
App.PostController = Ember.ObjectController.extend(
  isEditing: false
  edit: ->
    @set "isEditing", true

  doneEditing: ->
    @set "isEditing", false
)
App.IndexRoute = Ember.Route.extend(redirect: ->
  @transitionTo "posts"
)
Ember.Handlebars.registerBoundHelper "date", (date) ->
  moment(date).fromNow()

window.showdown = new Showdown.converter()

Ember.Handlebars.registerBoundHelper "markdown", (input) ->
  new Ember.Handlebars.SafeString(window.showdown.makeHtml(input))


App.Router.map ->
  @resource "about"
  @resource "posts", ->
    @resource "post",
      path: ":post_id"

