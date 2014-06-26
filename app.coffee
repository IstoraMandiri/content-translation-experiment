# Transparent usage

@Biographies = new Meteor.Collection 'biographies'


if Meteor.isServer

  i18n_db.publish 'biographies', Biographies


if Meteor.isClient

  i18n_db.subscribe 'biographies', Biographies

  Template.hello.bios = -> Biographies.find({type:'manager'})




##
# seed data for a demo
##

if Meteor.isServer

  if !Biographies.find().count()

    bios = [
      age: 36
      title : 'No Name Translation in French, Fallsback to Eng'
      name : 'Joe Smith'
      type: 'manager'
      i18n:
        zh:
          title : '首席执行官'
          name : '乔 - 史密斯'
        fr:
          title : 'Chef de la direction'
          # name does not exist so falls back to default
    ,
      age: 23
      title : 'Only has has one translation'
      name : 'Chris H'
      type: 'manager'
      i18n:
        zh:
          title : '首席执行官'
    ,
      age: 28
      title : 'Not a manager'
      name : 'Steve'
      type: 'hr'
      i18n:
        zh:
          title : '首席执行官'

    ]


    for bio in bios
      Biographies.insert bio