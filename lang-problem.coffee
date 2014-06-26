
@Biographies = new Meteor.Collection 'biographies'
# @Translations = new Meteor.Collection 'translations'

if Meteor.isServer

  if !Biographies.find().count()
    # testId = Translations.insert
    #   'tag' : 'en'
    #   'string' : 'TEST NAME'

    bioId = Biographies.insert
      age: 36
      type: 'Manager'
      'title' : 'Hello'
      'name' : 'Joe'
      i18n:
        zh:
          'title' : 'Hello2'
          'name' : 'Joe2'
    # Biographies.before.find (userId, selector, options) ->
    # options.fields?= {}
    # options.fields.i18n = 0

  # Biographies.before.find (userId, selector, options, cursor) ->
  #   @args[1] = {lang:'en'}

  # tappublish 'some_name', ->


  # all all functionality of regular meteor collections

  # TAPublish = (name, collection, query, options) ->
  #   console.log 'publishing', name, collection, query, options

  # TAPublish 'biographies', Biographies

  Meteor.publish 'biographies', -> Biographies.find({},{fields:{i18n:0}})
  Meteor.publish 'biographies_i18n', (tag) ->
    fields = {}
    fields["i18n.#{tag}"] = 1
    Biographies.find({},{fields:fields})


if Meteor.isClient

  # extend subscribe to add the current language transparently?
  Meteor.subscribe 'biographies'
  Deps.autorun ->
    Meteor.subscribe 'biographies_i18n', Session.get('language')

  # map i18n to object if key exists
  Biographies.before.find (userId, selector={}, options={}) ->
    @args[1] =
      transform: (doc) ->
        if doc.i18n
          for key, val of doc.i18n[Object.keys(doc.i18n)[0]]
            if doc[key]?
              doc[key] = val
          delete doc.i18n
        return doc


# Transparent usage
  Template.hello.helpers
    "bios" : -> Biographies.find({})

