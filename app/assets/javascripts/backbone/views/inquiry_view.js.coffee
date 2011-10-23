TestDouble.Views.Inquiries ||= {}

class TestDouble.Views.InquiryView extends Backbone.View
  template: JST["backbone/templates/inquiry"]

  events:
    "click .send": "save",
    'change :input[name="category"]': "renderCurrentCategory"

  initialize: ->
    @model = new @collection.model()
    @model.bind "change:errors", () => @render()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.set fullInquiryText: @printForm(@$('form'))
    @model.unset("errors")

    @collection.create @model.toJSON(),
      success: (inquiry) =>
        @model = inquiry

      error: (inquiry, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText) })

  render: ->
    $(@el).html(@template(@model.toJSON()))
    @$("form").backboneLink(@model)
    @renderCurrentCategory()
    @

  renderCurrentCategory: ->
    selectedClass = @$(':input[name="category"] :selected').attr('class')
    @$('.category').each (i,el) ->
      $el = $(el)
      shouldShow = $el.hasClass(selectedClass)
      $el.toggleClass('hidden',!shouldShow)


  #private

  printForm: ($root) =>
    s = ""
    _($root.contents()).each (el) ->
      $el = $(el)
      s += '\n\n' if $el.is('div')
      if @textNode(el)
        text = _(el.textContent).clean()
        s += @padIfAlphabetic(text) + text + ' '
      else if $el.is(':input')
        s += $el.val() || "__[#{$el.attr('name')}]__" unless $el.is('button')
      else
        s += @printForm $el
    ,@
    s

  textNode: (el) ->
    el.nodeType == 3

  padIfAlphabetic: (content) =>
    if content.match(/^[A-z]/) then ' ' else ''