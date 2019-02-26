class Generator
    new: =>
        @pieces = {'I','J','L','O','S','T','Z'}
        @bag = {}
        @upcoming = {}

    genBag: =>
        @bag = Utils.copyTable Utils.shuffle @pieces

    getUpcoming: (remove=false, n=1) =>
        while #@upcoming < n
            if #@bag == 0
                @genBag!
            table.insert @upcoming, table.remove(@bag, 1)
        if n == 1
            if remove
                return table.remove @upcoming, 1
            return @upcoming[1]
        else
            pieces = {}
            for i = 1, n
                table.insert pieces, @upcoming[i]
            if remove
                for i = 1, n
                    table.remove @upcoming, 1
            return pieces

return Generator