###############################################################################
# Toggles hiding and showing content with an accordion efffect
###############################################################################
"use strict"

( ($) ->
    class window.DrmTableSorter
        constructor: (@tableClass = 'drm-sortable-table') ->
            self = @
            self.table = $ ".#{@tableClass}"
            self.buttonClass = 'drm-sortable-table-button'
            
            self.ignore = [
                'the'
                'a'
            ]

            self.patterns =
                number: new RegExp "^(?:\\-?\\d+|\\d*)(?:\\.?\\d+|\\d)$"
                alpha: new RegExp '[a-z ,.\\-]*','i'
                # mm/dd/yyyy
                monthDayYear: new RegExp '^(?:[0]?[1-9]|[1][012]|[1-9])[-\/.](?:[0]?[1-9]|[12][0-9]|[3][01])(?:[-\/.][0-9]{4})'
                # 00:00pm
                time: new RegExp '^(?:[12][012]|[0]?[0-9]):[012345][0-9](?:am|pm)', 'i'

            self.table.on 'click', ".#{@buttonClass}", ->
                values = self.getData $(@).parent().index()
                self.addActiveClass.call @
                self.renderTable values, $(@).data('dir')

        addActiveClass: ->
            that = $ @
            container = that.parent()
            row = container.parent()
            row.find('.drm-sortable-table-button.active').removeClass 'active'
            that.addClass 'active'

        getData: (columnNum) =>
            values = []
            rows = @table.find 'tbody tr'

            $.each rows, (key, value) ->
                text = $.trim $(value).find('td').eq(columnNum).text()
                if text.length > 0 then values.push $(value).find('td').eq(columnNum).text()

            values

        getDataType: (values) =>
            type = null
            self = @

            _isDate = (value) ->
                if @patterns.monthDayYear.test(value) then true else false

            _isNumber = (value) ->
                if @patterns.number.test(value) then true else false

            _isAlpha = (value) ->
                if @patterns.alpha.test(value) then true else false

            _isTime = (value) ->
                if @patterns.time.test(value) then true else false

            $.each values, (key, value) ->
                if _isDate.call self, value
                    type = 'date'
                else if _isTime.call self, value
                    type = 'time'
                else if _isNumber.call self, value
                    type = 'number'
                else if _isAlpha.call self, value
                    type = 'alpha'
                else
                    type = null
            type

        sortValues: (values, direction) =>
            self = @
            type = self.getDataType values

            if !type
                values = null

            else if type is 'date'
                _sortAsc = (a, b) ->
                    a = new Date self.patterns.monthDayYear.exec(a)
                    b = new Date self.patterns.monthDayYear.exec(b)
                    a - b

                _sortDesc = (a, b) ->
                    a = new Date self.patterns.monthDayYear.exec(a)
                    b = new Date self.patterns.monthDayYear.exec(b)
                    b - a

                values = if direction is 'ascending' then values.sort _sortAsc else values.sort _sortDesc        

            else if type is 'time'
                _parseTime = (time) ->
                    hour = parseInt(/^(\d+)/.exec(time)[1], 10)
                    minutes = /:(\d+)/.exec(time)[1]
                    ampm = /(am|pm|AM|PM)$/.exec(time)[1].toLowerCase()

                    if ampm is 'am'
                        hour = hour.toString()
                        
                        if hour is '12'
                            hour = '0'
                        else if hour.length is 1
                            hour = "0#{hour}"
                            
                        time24 = "#{hour}:#{minutes}"

                    else if ampm is 'pm'
                        time24 = "#{hour + 12}:#{minutes}"

                _sortAsc = (a, b) ->
                    a = _parseTime self.patterns.time.exec(a)
                    b = _parseTime self.patterns.time.exec(b)
                    new Date("04-22-2014 #{a}") - new Date("04-22-2014 #{b}")

                _sortDesc = (a, b) ->
                    a = _parseTime self.patterns.time.exec(a)
                    b = _parseTime self.patterns.time.exec(b)
                    new Date("04-22-2014 #{b}") - new Date("04-22-2014 #{a}")

                values = if direction is 'ascending' then values.sort _sortAsc else values.sort _sortDesc

            else if type is 'alpha'
                _sortAsc = (a, b) ->
                    a = a.toLowerCase()
                    b = b.toLowerCase()
                    if a < b
                        -1
                    else if a > b
                        1
                    else if a is b
                        0

                _sortDesc = (a, b) ->
                    a = a.toLowerCase()
                    b = b.toLowerCase()
                    if a < b
                        1
                    else if a > b
                        -1
                    else if a is b
                        0

                values = if direction is 'ascending' then values.sort _sortAsc else values.sort _sortDesc

            else if type is 'number'
                _sortAsc = (a, b) ->
                    parseFloat(a) - parseFloat(b)

                _sortDesc = (a, b) ->
                    parseFloat(b) - parseFloat(a)

                values = if direction is 'ascending' then values.sort _sortAsc else values.sort _sortDesc
    
        renderTable: (values, direction) =>
            sortedValues = @.sortValues values, direction
            rows = @table.find 'tr'
            console.log sortedValues

    new DrmTableSorter()

) jQuery