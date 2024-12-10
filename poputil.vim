vim9script

export class SmartScrollPopup
    var _lines: list<any>
    var _saved_firstline: number = 1
    var _saved_lnum: number = 1
    var _opts: dict<any> = {
        max_height: 6,
        max_width: 100,
    }
    var _winid: number = -1

    def new(lines: list<any>, opts: dict<any> = {})
        this._lines = lines
        for [k, v] in opts->items()
            this._opts[k]
        endfor
    enddef

    def Show()
        assert_true(!this._lines->empty()
            && (typename(this._lines[0]) == typename('')
                || typename(this._lines) =~ '^list<dict<')
        )
        this._winid = popup_create(this._lines, {
            filter: this._ConsumeKey,
            firstline: this._saved_firstline,
            cursorline: true,
            border: [],
            padding: [0, 1, 0, 1],
            maxheight: this._opts.max_height,
            minwidth: this._ComputeTextWidth(),
            maxwidth: this._opts.max_width,
            wrap: false, # <NOTE> this is important
            callback: this._HandleExit
        })
        $':noa call cursor({this._saved_lnum}, 1)'->win_execute(this._winid)
    enddef

    def UpdateLines(new_lines: list<any>)
        assert_true(!new_lines->empty())
        echom 'UpdateLines called.'
        this._lines = new_lines
        this._winid->popup_settext(new_lines)
        # if new_lines->len() >= this._lines->len()
        #     echom "case 1, extending list"
        #     this._lines = new_lines
        #     this._winid->popup_settext(new_lines)
        # elseif new_lines->len() >= this._lnum
        #     # echom "case 2, shortening list, but cursor shouldn't move"
        #     this._lines = new_lines
        #     this._winid->popup_settext(new_lines)
        #     echom 'firstline= ' .. line('w0', this._winid)
        # else
        #     throw 'ERROR not implemented'
        # endif
        this._winid->popup_setoptions({minwidth: this._ComputeTextWidth()})
        # redraw
    enddef

    def _ComputeTextWidth(): number
        if typename(this._lines[0]) == typename('')
            return this._lines->mapnew((_, line) => line->strcharlen())->max()
        endif
        assert_true(typename(this._lines) =~ '^list<dict<')
        return this._lines->mapnew((_, line) => line.text->strcharlen())->max()
    enddef

    # reference: https://github.com/vim/vim/blob/src/popupwin.c#L685
    def _ConsumeKey(winid: number, key: string): bool
        if key == 'j'
            if this._winid->getcurpos()[1] >= this._lines->len()
                return true
            endif
        elseif key == 'k'
            if this._winid->getcurpos()[1] <= 1
                return true
            endif
        # DEBUG {{{
        elseif key == 'U'
            # var newlines = this._lines + this._lines->mapnew((_, line) => $'** {line}')
            var newlines = this._lines[: 14]
            this.UpdateLines(newlines)
        # }}}
        endif
        return popup_filter_menu(winid, key)
    enddef

    def _HandleExit(winid: number, line_num: number)
        this._saved_lnum = winid->getcurpos()[1]
        this._saved_firstline = 'w0'->line(winid)
    enddef

endclass
