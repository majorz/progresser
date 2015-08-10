(($) ->

   class Progresser
      constructor: (@name) ->
         @_totalWeight = 0
         @_currentWeight = 0
         @_debug = false

         @deferred = new $.Deferred()

      setup: (options) ->
         @_totalWeight = options.totalWeight
         @_debug = options.debug if console?

         if @_debug
            @_logTime false
            @_logWeight()

         return

      advance: (weight) ->
         @_currentWeight += weight

         if @_debug
            @_logTime true
            @_logWeight()

         @deferred.notify @_currentWeight, @_totalWeight

         return

      collect: ->
         advance = @advance
         complete = @_complete

         imagesComplete = (instance) =>
            @_complete()
            return

         imageLoaded = (instance, image) =>
            weight = $ image.img
               .data 'weight'
            @advance weight
            return

         $ '.progresser-wait'
            .voila method: 'onload'
            .always imagesComplete
            .progress imageLoaded

         return

      _complete: ->
         @deferred.resolve()

         if @_debug
            @_logComplete()

         return

      _logWeight: ->
         console.log 'progresser weight:', @_currentWeight, 'of', @_totalWeight
         return

      _logTime: (timeEnd) ->
         if timeEnd
            console.timeEnd 'progresser'

         console.time 'progresser'

         return

      _logComplete: ->
         console.log 'progresser completed'
         return


   instance = new Progresser()

   $.progresser = instance.deferred.promise instance

   return
) jQuery
