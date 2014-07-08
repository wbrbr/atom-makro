###
# This file is the entry point of your package. It will be loaded once as a
# singleton.

Dawson Reid (dreid93@gmail.com)
###

MakefileView = require './views/makefile_view'
MakefileSearchView = require './views/makefile_search_view'
Makefile = require './models/makefile'

module.exports =

  setupCommands: ->
    wV = atom.workspaceView
    wV.command 'makro:toggleMainMakefile', => @toggleMainMakefile()
    wV.command 'makro:toggleMakefileSearch', => @makefileSearchView.toggle()

  ###
  # This required method is called when your package is activated.
  ###
  activate: (state) ->
    console.log 'activate(state)'
    console.log state

    @setupCommands()

    @makefileView = new MakefileView()
    @makefileSearchView = new MakefileSearchView @makefileView

    project = atom.project
    directory = project.getRootDirectory()

    directory.getEntries do (makro = @) ->
      (err, entries) ->
        if err
          console.log 'Error :', err

        for entry in entries
          if entry.isFile() and entry.getBaseName() == 'Makefile'
            console.log 'found main makefile'
            makro.mainMakefile = new Makefile(entry)
            return

    console.log directory

  ###
  # This optional method is called when the window is shutting down, allowing
  # you to return JSON to represent the state of your component.
  ###
  serialize: ->
    console.log 'serialize()'

  ###
  # This optional method is called when the window is shutting down.
  ###
  deactivate: ->
    console.log 'deactivate()'

  toggleMainMakefile: ->

    console.log 'makro.toggleMainMakefile'
    @makefileView.setMakefile @mainMakefile
    @makefileView.toggle()
