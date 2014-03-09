###############################################################################
# Displays tooltips on click
###############################################################################

( ($) ->
	
    drmTooltips = {
        config: {
            tooltip: $ '.drm-has-tooltip'
            speed: 300
        }

        init: (config) ->
            $.extend @config, config

            drmTooltips.config.tooltip.on 'mouseenter', @.addTooltip
            drmTooltips.config.tooltip.on 'mouseleave', @.removeTooltip

        addTooltip: ->
            that = $ @
            content = that.data 'title'
            oldTooltip = $ "div.drm-tooltip-#{position}:contains(#{content})"
            position = that.data 'position'

            if oldTooltip.length == 0
                newTooltip = $ '<div></div>', {
                    text: content,
                    class: "drm-tooltip-#{position}"
                }

                newTooltip.hide().insertBefore that
                tooltipCSS = drmTooltips.positionTooltip.call(that, newTooltip, position)

                newTooltip.css(tooltipCSS).fadeIn drmTooltips.config.speed

        positionTooltip: (newTooltip, position) ->
            that = $ @
            positionTop = that.offset().top + parseInt(that.css('padding-top'), 10)
            positionLeft = that.offset().left + parseInt(that.css('padding-left'), 10)
            height = parseInt(newTooltipouterHeight()
            width = parseInt(newTooltip.outerWidth()
            elWidth = parseInt(that.outerWidth()
            elHeight = parseInt(that.outerHeight()

            if position == 'left'
                tooltipTop = positionTop - (elHeight / 2)
                tooltipLeft = positionLeft - width + 10
            else if position == 'right'
                tooltipTop = positionTop - (elHeight / 2)
                tooltipLeft = positionLeft + elWidth + 15
            else if position == 'bottom'
                tooltipTop = positionTop
                tooltipLeft = positionLeft
            else
                tooltipTop = positionTop - ((elHeight + height) / 2) - 10
                tooltipLeft = positionLeft + ((elWidth + width) / 2)

            console.log "Top: #{tooltipTop} #{positionTop}, Left: #{tooltipLeft} #{positionLeft}"
            console.log "Height: #{height} #{elHeight}, Width: #{width} #{elWidth}"
            tooltipCSS = {'top': "#{tooltipTop}px", 'left': "#{tooltipLeft}px"}

            return tooltipCSS            

        removeTooltip: ->
            that = $ @
            content = that.data 'title'
            position = that.data 'position'
            oldTooltip = $ "div.drm-tooltip-#{position}:contains(#{content})"

            if oldTooltip.length > 0
                oldTooltip.fadeOut drmTooltips.config.speed, ->
                    $(@).remove()
    }

    drmTooltips.init()

) jQuery