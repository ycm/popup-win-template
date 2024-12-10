# popup-win-template

[wip] `+popup_win` boilerplate for better popup windows

**todo**

- [x] prevent wraparound scrolling
- [x] remember cursor position
- [x] accept `list<string>` in constructor
- [x] accept `list<dict<any>>` in constructor
- [ ] refresh windows text and infer cursorline position
- [ ] define keys in `opts`
- [ ] display and ingest input on certain keys

**usage**

```
import "./poputil.vim" as util
var lines = [
    '1. Nulla facilisi.',
    '2. Ut sed auctor neque.',
    '3. Sed a fringilla nunc.',
    '4. Donec ac laoreet erat.'
]
var win = util.SmartScrollPopup.new(lines)
command! Pop win.Show()
```

for more complex text properties `lines` can also be `list<dict<any>>`, as in

```
var lines = [
    {text: 'hello', props=[{...}, {...}]},
    {text: 'world', props=[{...}, {...}]}
]
```

the constructor has the following signature:
```
new(lines: list<any>, opts: dict<any> = {})
```

**notes**

- uses `popup_create(..., {cursorline: true})`, which overrides text properties in `props`; might be good idea to clear either `fg` or `bg` attr of `PMenuSel`
