vim9script

export class Scroller
    var _lines: list<any>
    var _saved_fline: number
    var _saved_lnum: number
    var _opts: dict<any> = {
        height: 10,
        max_width: 100,
        min_width: 50
    }
    var _winid: number = -1

    def new(lines: list<any>, opts: dict<any> = {})
        assert_true(lines->empty()
            || (typename(lines[0]) == typename('')
                || typename(lines) =~ '^list<dict<'))
        this._lines = lines
        for [k, v] in opts->items()
            this._opts[k] = v
        endfor
        [this._saved_fline, this._saved_lnum] = lines->empty() ? [0, 0] : [1, 1]
    enddef

    def Show()
        this._winid = popup_create(this._lines, {
            filter: this._ConsumeKey,
            firstline: this._saved_fline,
            cursorline: true,
            border: [],
            padding: [0, 1, 0, 1],
            maxheight: this._opts.height,
            minheight: this._opts.height,
            minwidth: this._ComputeTextWidth(),
            maxwidth: this._opts.max_width,
            wrap: false, # <NOTE> this is important
            callback: this._HandleExit
        })
        $':noa call cursor({this._saved_lnum}, 1)'->win_execute(this._winid)
    enddef

    def UpdateLines(new_lines: list<any>)
        var curr_line = this._winid->getcurpos()[1]
        var new_len = new_lines->len()
        this._winid->popup_settext(new_lines)
        this._lines = new_lines
        if curr_line > new_len
            var new_lnum = [curr_line, new_len]->min()
            var new_fline = [1, new_len - this._opts.height + 1]->max()
            $':noa call cursor({new_lnum}, 1)'->win_execute(this._winid)
            this._winid->popup_setoptions({firstline: new_fline})
        endif
    enddef

    def _ComputeTextWidth(): number
        var width = this._opts.min_width
        if this._lines->empty()
            return width
        elseif typename(this._lines[0]) == typename('')
            width = this._lines->mapnew((_, line) => line->strcharlen())->max()
        else
            width = this._lines->mapnew((_, line) => line.text->strcharlen())->max()
        endif
        return [width, this._opts.min_width]->max()
    enddef

    def _ConsumeKey(winid: number, key: string): bool
        # reference: https://github.com/vim/vim/blob/src/popupwin.c#L685
        if key == 'j'
            if this._winid->getcurpos()[1] >= this._lines->len()
                return true
            endif
        elseif key == 'k'
            if this._winid->getcurpos()[1] <= 1
                return true
            endif
        endif
        return popup_filter_menu(winid, key)
    enddef

    def _HandleExit(winid: number, line_num: number)
        this._saved_lnum = winid->getcurpos()[1]
        this._saved_fline = 'w0'->line(winid)
    enddef
endclass
