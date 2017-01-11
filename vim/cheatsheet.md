# Vim

Consider learning from [Wincent's](https://wincent.com/wiki/Vim_cheatsheet) as well.
[VIM Quick Reference](http://tnerual.eriogerg.free.fr/vimqrc.html).

## Vim jumplist

Vim stores every jump you make when editing files in the viminfo file. You can jump to an `O`lder place by:

`CTRL+o`

And to a newer with:

`CTRL+i`

You can display all the jumps you've made with:

`:jumps`

## Shortcuts

### Normal mode

- Undo: u
- Redo: C-r
- Switching tabs: gt or gT
- Navigate through windows: <C-w> + h, j, k or l
- Indent: >
- Unindent: <
- Fix indentation: =

### Text objects

- Word: w
- Block: B, [, (

### Surround

Check [tutorial](http://www.futurile.net/2016/03/19/vim-surround-plugin-tutorial/)

- Add surround in normal mode: ys{ _(yank surround {)_
- Delete surround in normal mode: ds{ _(delete surround {)_
- Change surround in normal mode: cs{[ _(change surround from { to [)_
- Add surround in visual mode: St _(add surround tag)_

#### Navigation

- Go to the top of screen: H
- Go to the middle of screen: M
- Go to the bottom of screen: L
- Scroll half page up: <C-u> _(up)_
- Scroll half page down: <C-d> _(down)_
- Scroll full page up: <C-b> _(backward)_
- Scroll full page down: <C-f> _(forward)_
- Jump to the begin of a method definition: ]m / [m
- Jump to the end of a method definition: ]M / [M

#### Search / Replace

- Search: /
- Force case insensitive search: /term\c
- Force case sensitive search: /term\C
- Rerun last search: //
- Replace: :%s/search/replacement/g
- Replace from last search: :%s//replacement/g
- Replace interactively: :%s//replacement/gc
- In visual mode, select a word and easily search all ocurrences in the document: <C-r> + <C-w>

#### Ferret Plugin

- Search all files by the yanked text: <Leader>s

#### Custom shortcuts

- Close a buffer: \w
- Enable indent guides: <Leader>ig
- Expand emmet: <C-y>,

#### Switching modes

- Insert mode (before the cursor): i
- Insert mode (after the cursor): a
- Insert mode (end of line): A
- Insert mode (begining of line): I
- Insert mode (create a line below): o
- Insert mode (create a line above): O
- Change case: ~
- Change: select someting then: c
- Change what's under the cursor: s
- Change an entire line: S
- Change until the end of line: C

# Basic operations

- Delete: x
- Delete backwards: X

#### NERDTree

- Toggle: <Leader>.
- Go to current file: <Leader>,
- Open a file in a new tab: o
- Open filesystem menu: m
- Refresh tree: r

#### Command T

- \t       bring up the Command-T file window
- \b       bring up the Command-T buffer window
- \j       bring up the Command-T jumplist window

### Insert mode

- Ident: C-t
- Un-indent: C-d
