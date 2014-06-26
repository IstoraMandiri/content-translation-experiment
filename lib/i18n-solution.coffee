
firstValue = (obj) -> if obj then obj[Object.keys(obj)[0]]

@i18n_db =

  publish : (name, collection, query={}, options={}) ->
    # mongo can only have a field whitelist or blacklist
    # detect and pass to the relvent function
    # this will ensure all field queries can be satisfied

    defaultPub = (fields) ->
      # return everything except i18n + field blacklist
      opts = _.clone options
      opts['fields'] = { i18n : 0 }
      Meteor.publish name, -> collection.find(query,opts)

    i18nPub = (fields) ->
      # return only relavent i18n + field whitelist
      Meteor.publish "#{name}_i18n", (tag) ->
        # this is we could add fields option query 1
        opts = _.clone options
        opts.fields = {}
        opts.fields["i18n.#{tag}"] = 1
        collection.find(query,opts)

    # enable all field queries
    fields = options.fields
    # if options.fields.key = 1 whitelist
    if firstValue fields
      i18nPub fields
      defaultPub()
    else
    # blacklist
      defaultPub fields
      i18nPub()


  subscribe : (name, collection) ->

    collection.before.find ->
      @args[0]?= {} # breaks if undefined
      @args[1] =
        transform: (doc) ->
          # map i18n string to original object if original key exists
          # TODO add safer / better mapping, maybe use _
          if doc.i18n
            for key, val of firstValue doc.i18n
              if doc[key]?
                doc[key] = val
            delete doc.i18n
          return doc

    # TODO Replace Session.get with tapi18n
    Deps.autorun ->
      Meteor.subscribe name
      Meteor.subscribe "#{name}_i18n", TAPi18n.getLanguage()


# TODO update hooks
