" PROJECT HANDLING

"Load projects from project json file. Format:
"{ "projects": [ {"name":"FOO", "root":"c:/projects/foo/", "workdir":"."}, ... ] }
"
let g:vimprj#currentProjectName = ""
let g:vimprj#projectFile = expand('~/vimprojects.json')
let g:vimprj#project = []
if (filereadable(g:vimprj#projectFile))
  let result = json_decode(readfile(g:vimprj#projectFile))
  for project in result["projects"]
    call add(g:vimprj#project, project)
  endfor
endif
call sort(g:vimprj#project)

function! Project(name, shouldSplit)
  for p in g:vimprj#project
    if p["name"] == a:name
      let root = p["root"]
      let workDir = root . "/" . p["workdir"]
      let projectFile = root . "/" . "project.vim"

      " enter project source root
      cd `=workDir`

      " run project override settings
      if (filereadable(projectFile))
        so `=projectFile`
      endif

      " Show project root directory
      if a:shouldSplit
        vnew `=root`
      else
        e `=root`
      endif
      wincmd L
      setlocal nonu
      let g:vimprj#currentProjectName = "Project:" . a:name . " | "
      call UpdateTitleBar()
    endif
  endfor
endfunction

com! -complete=customlist,ListProjects -nargs=1 Proj call Project(<f-args>, 0)

function! ListProjects(A,L,P)
  let names = []
  echo a:A
  for p in g:vimprj#project
    call add(names, p["name"])
  endfor
  return filter(l:names, 'v:val =~ "^' . a:A . '"')
endfun

set title
augroup dirchange
  autocmd!
	autocmd BufEnter * call UpdateTitleBar()
augroup END

function! UpdateTitleBar()
  let &titlestring = g:vimprj#currentProjectName . getcwd() ." > ".  expand("%:p")  
endfunction
