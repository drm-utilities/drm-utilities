###############################################################################
# A simple jQuery slider
###############################################################################
"use strict"

( ($) ->
    drmSimpleSlider =
        slider: $ 'div.drm-simple-slider'
        slideHolder: $ 'div.drm-simple-slide-holder'
        slideList: $ 'ul.drm-simple-slider-list'        

        config:
            play: 10000
            speed: 300
            animate: yes

        init: (config) ->
            $.extend @config, config
            slides = @slideHolder.find 'div.drm-simple-slide'
            current = 0
            sliderControls = $('div.drm-simple-slider-nav').find 'button'

            ## Initialize
            
            if slides.length > 1
                sliderControls.show()
                @slideList.show()
                @slideList.find('button').first().addClass 'active'
                slides.hide()
                slides.first().show()
            else
                sliderControls.hide()
                @slideList.hide()
                slides.first().show()

            unless drmSimpleSlider.config.animate is no
                begin = @startShow()
                pause = -> drmSimpleSlider.pauseShow begin
                $(window).on 'load', $.proxy begin
                @slideHolder.on 'mouseenter', pause

            sliderControls.on 'click', @advanceImage
            @slideList.on 'click', 'button', @goToImage

        getCurrent: ->            
            slides = drmSimpleSlider.slideHolder.find '.drm-simple-slide'
            currentSlide = slides.not ':hidden'
            current = slides.index currentSlide

            current

        advanceImage: ->
            slides = drmSimpleSlider.slideHolder.find '.drm-simple-slide'
            last = slides.length - 1
            current = drmSimpleSlider.getCurrent()
            dir = $(@).data 'dir'

            nextImage = (current) ->
                if current is last then next = 0 else next = current + 1
                next

            prevImage = (current) ->
                if current is 0 then next = last else next = current - 1
                next

            next = if dir is 'prev' then prevImage(current) else nextImage(current)

            drmSimpleSlider.replaceImage(current, next)       

        goToImage: ->
            current = drmSimpleSlider.getCurrent()
            next = $(@).data 'item-num'
            drmSimpleSlider.replaceImage(current, next)

        replaceImage: (current, next) ->
            links = drmSimpleSlider.slideList.find 'button'
            speed = drmSimpleSlider.config.speed
            slides = drmSimpleSlider.slideHolder.find '.drm-simple-slide'

            slides.eq(current).fadeOut speed, ->
                slides.eq(next).fadeIn speed
                links.removeClass 'active'
                links.eq(next).addClass 'active'

        startShow: ->
            slides = drmSimpleSlider.slideHolder.find '.drm-simple-slide'
            nextControl = $('.drm-simple-slider-nav').find "button[data-dir='next']"

            unless slides.length is 0            
                start = setInterval ->
                    nextControl.trigger 'click'
                , drmSimpleSlider.config.play
            start

        pauseShow: (start) ->
            clearInterval start

    drmSimpleSlider.init()

) jQuery