let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

ruby << EOF
  plugin_root_dir = VIM::evaluate('s:plugin_root_dir') 
  require_relative "#{plugin_root_dir}/ruby/better_goto.rb"
EOF

function! GotoDefinition()
ruby << EOF
  window = VIM::Window.current
  cursor = window.cursor
  buffer = VIM::Buffer.current
  window.cursor = BetterGoto.new.goto_definition(cursor, buffer)
EOF
endfunction
