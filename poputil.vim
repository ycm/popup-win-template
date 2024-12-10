vim9script

export class SmartScrollPopup
    var _lines: list<any>
    var _curr_line: number = 1
    var _opts: dict<any> = {
        max_height: 15,
        max_width: 100,
    }
    var _wid: number = -1

    def new(lines: list<any>, opts: dict<any> = {})
        this._lines = lines
        for [k, v] in opts->items()
            this._opts[k]
        endfor
    enddef

    def Show()
        var first_line = this._ComputeFirstLine()
        this._wid = popup_create(this._lines, {
            filter: this._ConsumeKey,
            firstline: first_line,
            cursorline: true,
            border: [],
            padding: [0, 1, 0, 1],
            maxheight: this._opts.max_height,
            minwidth: this._ComputeTextWidth(),
            maxwidth: this._opts.max_width,
            wrap: false, # <NOTE> this is important
            callback: this._HandleExit
        })
        win_execute(this._wid, $':noa call cursor({this._curr_line}, 1)')
    enddef

    def _ComputeFirstLine(): number
        var nlines = this._lines->len()
        var edge = this._curr_line - (this._opts.max_height - 1) / 2
        if edge < 1
            return 1
        endif
        if this._curr_line + this._opts.max_height / 2 > nlines
            return nlines - this._opts.max_height + 1
        endif
        return edge
    enddef

    def _ComputeTextWidth(): number
        if this._lines->empty()
            return 0
        endif
        if typename(this._lines[0]) == typename('')
            return this._lines->mapnew((_, line) => line->strcharlen())->max()
        endif
        assert_true(typename(this._lines) =~ '^list<dict<')
        return this._lines->mapnew((_, line) => line.text->strcharlen())->max()
    enddef

    def _ConsumeKey(winid: number, key: string): bool
        if key == 'j'
            if this._curr_line >= this._lines->len()
                return true
            endif
            ++this._curr_line
        elseif key == 'k'
            if this._curr_line <= 1
                return true
            endif
            --this._curr_line
        endif
        return popup_filter_menu(winid, key)
    enddef

    def _HandleExit(winid: number, line_num: number)
        echom $'{winid}, {line_num}'
    enddef

endclass
